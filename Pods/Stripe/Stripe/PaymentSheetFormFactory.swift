//
//  PaymentSheetFormFactory.swift
//  StripeiOS
//
//  Created by Yuki Tokuhiro on 6/9/21.
//  Copyright © 2021 Stripe, Inc. All rights reserved.
//

import UIKit
@_spi(STP) import StripeCore
import SwiftUI
@_spi(STP) import StripeUICore

/**
 This class creates a FormElement for a given payment method type and binds the FormElement's field values to an
 `IntentConfirmParams`.
 */
class PaymentSheetFormFactory {
    enum SaveMode {
        /// We can't save the PaymentMethod. e.g., Payment mode without a customer
        case none
        /// The customer chooses whether or not to save the PaymentMethod. e.g., Payment mode
        case userSelectable
        /// `setup_future_usage` is set on the PaymentIntent or Setup mode
        case merchantRequired
    }
    let saveMode: SaveMode
    let paymentMethod: STPPaymentMethodType
    let intent: Intent
    let configuration: PaymentSheet.Configuration
    let addressSpecProvider: AddressSpecProvider
    let offerSaveToLinkWhenSupported: Bool
    let linkAccount: PaymentSheetLinkAccount?

    var canSaveToLink: Bool {
        return (
            intent.supportsLink &&
            paymentMethod == .card &&
            saveMode != .merchantRequired
        )
    }

    init(
        intent: Intent,
        configuration: PaymentSheet.Configuration,
        paymentMethod: STPPaymentMethodType,
        addressSpecProvider: AddressSpecProvider = .shared,
        offerSaveToLinkWhenSupported: Bool = false,
        linkAccount: PaymentSheetLinkAccount? = nil
    ) {
        switch intent {
        case let .paymentIntent(paymentIntent):
            let merchantRequiresSave = paymentIntent.setupFutureUsage != .none
            let hasCustomer = configuration.customer != nil
            let isPaymentMethodSaveable = PaymentSheet.supportsSaveAndReuse(paymentMethod: paymentMethod, configuration: configuration, intent: intent)
            switch (merchantRequiresSave, hasCustomer, isPaymentMethodSaveable) {
            case (true, _, _):
                saveMode = .merchantRequired
            case (false, true, true):
                saveMode = .userSelectable
            case (false, true, false):
                fallthrough
            case (false, false, _):
                saveMode = .none
            }
        case .setupIntent:
            saveMode = .merchantRequired
        }
        self.intent = intent
        self.configuration = configuration
        self.paymentMethod = paymentMethod
        self.addressSpecProvider = addressSpecProvider
        self.offerSaveToLinkWhenSupported = offerSaveToLinkWhenSupported
        self.linkAccount = linkAccount
    }
    
    func make() -> PaymentMethodElement {
        // Card is not yet converted to Element
        if paymentMethod == .card {
            return makeCard()
        } else if paymentMethod == .linkInstantDebit {
            return ConnectionsElement()
        }

        let formElements: [Element] = {
            switch paymentMethod {
            case .bancontact:
                return makeBancontact()
            case .iDEAL:
                return makeIdeal()
            case .sofort:
                return makeSofort()
            case .SEPADebit:
                return makeSepa()
            case .giropay:
                return makeGiropay()
            case .EPS:
                return makeEPS()
            case .przelewy24:
                return makeP24()
            case .afterpayClearpay:
                return makeAfterpayClearpay()
            case .klarna:
                return makeKlarna()
            case .affirm:
                return makeAffirm()
            case .AUBECSDebit:
                return makeAUBECSDebit()
            case .payPal:
                return []
            default:
                fatalError()
            }
        }() + [makeSpacer()] // For non card PMs, add a spacer to the end of the element list to match card bottom spacing

        return FormElement(formElements)
    }
}

extension PaymentSheetFormFactory {
    // MARK: - DRY Helper funcs
    
    func makeFullName() -> PaymentMethodElementWrapper<TextFieldElement> {
        let element = TextFieldElement.Address.makeFullName(defaultValue: configuration.defaultBillingDetails.name)
        return PaymentMethodElementWrapper(element) { textField, params in
            params.paymentMethodParams.nonnil_billingDetails.name = textField.text
            return params
        }
    }
    
    func makeEmail() -> PaymentMethodElementWrapper<TextFieldElement>  {
        let element = TextFieldElement.Address.makeEmail(defaultValue: configuration.defaultBillingDetails.email)
        return PaymentMethodElementWrapper(element) { textField, params in
            params.paymentMethodParams.nonnil_billingDetails.email = textField.text
            return params
        }
    }
    
    func makeBSB() -> PaymentMethodElementWrapper<TextFieldElement> {
        let element = TextFieldElement.Account.makeBSB(defaultValue: nil)
        return PaymentMethodElementWrapper(element) { textField, params in
            let bsbNumberText = BSBNumber(number: textField.text).bsbNumberText()
            params.paymentMethodParams.auBECSDebit?.bsbNumber = bsbNumberText
            return params
        }
    }

    func makeAUBECSAccountNumber() -> PaymentMethodElementWrapper<TextFieldElement> {
        let element = TextFieldElement.Account.makeAUBECSAccountNumber(defaultValue: nil)
        return PaymentMethodElementWrapper(element) { textField, params in
            params.paymentMethodParams.auBECSDebit?.accountNumber = textField.text
            return params
        }
    }

    func makeMandate() -> StaticElement {
        return StaticElement(view: SepaMandateView(merchantDisplayName: configuration.merchantDisplayName))
    }
    
    func makeSaveCheckbox(didToggle: @escaping ((Bool) -> ())) -> PaymentMethodElementWrapper<SaveCheckboxElement> {
        let element = SaveCheckboxElement(appearance: configuration.appearance, didToggle: didToggle)
        return PaymentMethodElementWrapper(element) { checkbox, params in
            if !checkbox.checkboxButton.isHidden {
                params.shouldSavePaymentMethod = checkbox.checkboxButton.isSelected
            }
            return params
        }
    }
    
    func makeBillingAddressSection() -> PaymentMethodElementWrapper<SectionElement> {
        let section = AddressSectionElement(
            title: String.Localized.billing_address,
            addressSpecProvider: addressSpecProvider,
            defaults: configuration.defaultBillingDetails.address.addressSectionDefaults
        )
        return PaymentMethodElementWrapper(section) { _, params in
            if let line1 = section.line1 {
                params.paymentMethodParams.nonnil_billingDetails.nonnil_address.line1 = line1.text
            }
            if let line2 = section.line2 {
                params.paymentMethodParams.nonnil_billingDetails.nonnil_address.line2 = line2.text
            }
            if let city = section.city {
                params.paymentMethodParams.nonnil_billingDetails.nonnil_address.city = city.text
            }
            if let state = section.state {
                params.paymentMethodParams.nonnil_billingDetails.nonnil_address.state = state.text
            }
            if let postalCode = section.postalCode {
                params.paymentMethodParams.nonnil_billingDetails.nonnil_address.postalCode = postalCode.text
            }
            params.paymentMethodParams.nonnil_billingDetails.nonnil_address.country = section.selectedCountryCode

            return params
        }
    }

    // MARK: - PaymentMethod form definitions

    func makeCard() -> PaymentMethodElement {
        var checkboxText: String? {
            guard saveMode == .userSelectable && !canSaveToLink else {
                // Hide checkbox
                return nil
            }

            return String(
                format: STPLocalizedString(
                    "Save this card for future %@ payments",
                    "The label of a switch indicating whether to save the user's card for future payment"
                ),
                configuration.merchantDisplayName
            )
        }

        let cardElement = CardDetailsEditView(
            checkboxText: checkboxText,
            includeCardScanning: true,
            configuration: configuration
        )

        guard offerSaveToLinkWhenSupported, canSaveToLink else {
            return cardElement
        }

        return LinkEnabledPaymentMethodElement(
            type: .card,
            paymentMethodElement: cardElement,
            configuration: configuration,
            linkAccount: linkAccount
        )
    }

    func makeBancontact() -> [PaymentMethodElement] {
        let name = makeFullName()
        let email = makeEmail()
        let mandate = makeMandate()
        let save = makeSaveCheckbox() { selected in
            email.element.isOptional = !selected
            mandate.isHidden = !selected
        }
        
        switch saveMode {
        case .none:
            return [name]
        case .userSelectable:
            return [name, email, save, mandate]
        case .merchantRequired:
            return [name, email, mandate]
        }
    }
    
    func makeSofort() -> [PaymentMethodElement] {
        let locale = Locale.current
        let countryCodes = locale.sortedByTheirLocalizedNames(
            /// A hardcoded list of countries that support Sofort
            ["AT", "BE", "DE", "IT", "NL", "ES"]
        )
        let country = PaymentMethodElementWrapper(DropdownFieldElement.Address.makeCountry(
            label: String.Localized.country,
            countryCodes: countryCodes,
            defaultCountry: configuration.defaultBillingDetails.address.country,
            locale: locale
        )) { dropdown, params in
            let sofortParams = params.paymentMethodParams.sofort ?? STPPaymentMethodSofortParams()
            sofortParams.country = countryCodes[dropdown.selectedIndex]
            params.paymentMethodParams.sofort = sofortParams
            return params
        }
        let name = makeFullName()
        let email = makeEmail()
        let mandate = makeMandate()
        let save = makeSaveCheckbox(didToggle: { selected in
            name.element.isOptional = !selected
            email.element.isOptional = !selected
            mandate.isHidden = !selected
        })
        switch saveMode {
        case .none:
            return [country]
        case .userSelectable:
            return [name, email, country, save, mandate]
        case .merchantRequired:
            return [name, email, country, mandate]
        }
    }

    func makeIdeal() -> [PaymentMethodElement] {
        let name = makeFullName()
        let banks = STPiDEALBank.allCases
        let items = banks.map { $0.displayName } + [String.Localized.other]
        let bank = PaymentMethodElementWrapper(DropdownFieldElement(
            items: items,
            label: String.Localized.ideal_bank
        )) { bank, params in
            let idealParams = params.paymentMethodParams.iDEAL ?? STPPaymentMethodiDEALParams()
            idealParams.bankName = banks.stp_boundSafeObject(at: bank.selectedIndex)?.name
            params.paymentMethodParams.iDEAL = idealParams
            return params
        }
        let email = makeEmail()
        let mandate = makeMandate()
        let save = makeSaveCheckbox(didToggle: { selected in
            email.element.isOptional = !selected
            mandate.isHidden = !selected
        })
        switch saveMode {
        case .none:
            return [name, bank]
        case .userSelectable:
            return [name, bank, email, save, mandate]
        case .merchantRequired:
            return [name, bank, email, mandate]
        }
    }

    func makeSepa() -> [PaymentMethodElement] {
        let iban = PaymentMethodElementWrapper(TextFieldElement.makeIBAN()) { iban, params in
            let sepa = params.paymentMethodParams.sepaDebit ?? STPPaymentMethodSEPADebitParams()
            sepa.iban = iban.text
            params.paymentMethodParams.sepaDebit = sepa
            return params
        }
        let name = makeFullName()
        let email = makeEmail()
        let mandate = makeMandate()
        let save = makeSaveCheckbox(didToggle: { selected in
            email.element.isOptional = !selected
            mandate.isHidden = !selected
        })
        let address = makeBillingAddressSection()
        switch saveMode {
        case .none:
            return [name, email, iban, address, mandate]
        case .userSelectable:
            return [name, email, iban, address, save, mandate]
        case .merchantRequired:
            return [name, email, iban, address, mandate]
        }
    }

    func makeGiropay() -> [PaymentMethodElement] {
        return [makeFullName()]
    }

    func makeEPS() -> [PaymentMethodElement] {
        return [makeFullName()]
    }

    func makeP24() -> [PaymentMethodElement] {
        return [makeFullName(), makeEmail()]
    }

    func makeAfterpayClearpay() -> [PaymentMethodElement] {
        guard case let .paymentIntent(paymentIntent) = intent else {
            assertionFailure()
            return []
        }
        let priceBreakdownView = StaticElement(
            view: AfterpayPriceBreakdownView(amount: paymentIntent.amount, currency: paymentIntent.currency)
        )
        return [priceBreakdownView, makeFullName(), makeEmail(), makeBillingAddressSection()]
    }
    
    func makeKlarna() -> [PaymentMethodElement] {
        guard case let .paymentIntent(paymentIntent) = intent else {
            assertionFailure("Klarna only be used with a PaymentIntent")
            return []
        }
        
        let countryCodes = Locale.current.sortedByTheirLocalizedNames(
            KlarnaHelper.availableCountries(currency: paymentIntent.currency)
        )
        let country = PaymentMethodElementWrapper(DropdownFieldElement.Address.makeCountry(
            label: String.Localized.country,
            countryCodes: countryCodes,
            defaultCountry: configuration.defaultBillingDetails.address.country,
            locale: Locale.current
        )) { dropdown, params in
            let address = STPPaymentMethodAddress()
            address.country = countryCodes[dropdown.selectedIndex]
            params.paymentMethodParams.nonnil_billingDetails.address = address
            return params
        }
        
        return [makeKlarnaCopyLabel(), makeEmail(), country]
    }

    func makeAUBECSDebit() -> [PaymentMethodElement] {
        let mandate = StaticElement(view: AUBECSLegalTermsView())
        return [makeBSB(), makeAUBECSAccountNumber(), makeEmail(), makeFullName(), mandate]
    }
    
    func makeAffirm() -> [PaymentMethodElement] {
        let label = StaticElement(view: AffirmCopyLabel())
        return [label]
    }
    
    func makeSpacer() -> StaticElement {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: STPFormView.interSectionSpacing).isActive =
            true
        
        return StaticElement(view: spacerView)
    }
    
    private func makeKlarnaCopyLabel() -> StaticElement {
        let klarnaLabel = UILabel()
        if KlarnaHelper.canBuyNow() {
            klarnaLabel.text = STPLocalizedString("Buy now or pay later with Klarna.", "Klarna buy now or pay later copy")
        } else {
            klarnaLabel.text = STPLocalizedString("Pay later with Klarna.", "Klarna pay later copy")
        }
        klarnaLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        klarnaLabel.textColor = CompatibleColor.secondaryLabel
        klarnaLabel.numberOfLines = 0
        return StaticElement(view: klarnaLabel)
    }
}

fileprivate extension FormElement {
    /// Conveniently nests single TextField and DropdownFields in a Section
    convenience init(_ autoSectioningElements: [Element]) {
        let elements: [Element] = autoSectioningElements.map {
            if $0 is PaymentMethodElementWrapper<TextFieldElement> || $0 is PaymentMethodElementWrapper<DropdownFieldElement> {
                return SectionElement($0)
            }
            return $0
        }
        self.init(elements: elements)
    }
}

extension STPPaymentMethodBillingDetails {
    var nonnil_address: STPPaymentMethodAddress {
        guard let address = address else {
            let address = STPPaymentMethodAddress()
            self.address = address
            return address
        }
        return address
    }
}

private extension PaymentSheet.Address {
    var addressSectionDefaults: AddressSectionElement.Defaults {
        return .init(
            city: city,
            country: country,
            line1: line1,
            line2: line2,
            postalCode: postalCode,
            state: state
        )
    }
}
