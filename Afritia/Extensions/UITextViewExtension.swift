//
//  File.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 22/04/19.
//  Copyright © 2019 Karan B. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    
    func setDefaultText(_ defaultText:String!)->Void{
        if self.text == "" ||  self.text == " " ||  self.text == nil{
            self.text = defaultText
        }
    }
    
    /*
    func isValidText() -> Bool {
        guard let text = self.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        return true
    }
    
    func isEmpty()->Bool{
        
        let whitespaceSet = CharacterSet.whitespacesAndNewlines
        if self.text.trimmingCharacters(in: whitespaceSet).isEmpty {
            return true // if text view is empty
        }
        return false
    }*/

    func isInvalidOrEmpty()->Bool{
        
        let whitespaceSet = CharacterSet.whitespacesAndNewlines
        if self.text.trimmingCharacters(in: whitespaceSet).isEmpty {
            return true // if text view is empty
        }
        return false
    }
    
    
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
        
        //https://stackoverflow.com/questions/39238366/uitextview-with-hyperlink-text
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        
        //attribute fullrange
        attributedOriginalText.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.black, range: fullRange)
        
        //atribute link range
        attributedOriginalText.addAttribute(NSAttributedStringKey.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.appGreen, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: linkRange)
        
        self.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.appGreen,
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
            ] as [String : Any]
        
        self.attributedText = attributedOriginalText
    }
    
}
