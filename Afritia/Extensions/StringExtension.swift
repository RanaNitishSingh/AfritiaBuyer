//
//  StringExtension.swift
//

import Foundation
import UIKit

public extension String {
    
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    static var uniqueGUID:String {
        get {
            return UUID().uuidString
        }
    }
    
    func isValidNumber() -> Bool {
        var isValid:Bool = false
        let num = Int(self)
        if num != nil {
            isValid = true
        }
        return isValid
    }
    
    func splitName() -> [String] {
        
        var sepratedName = [String]()
        var components = self.components(separatedBy: " ")
        if components.count > 0 {
            let firstName = components.removeFirst()
            let lastName = components.joined(separator: " ")
            debugPrint(firstName)
            debugPrint(lastName)
            
            if firstName.count > 0 {
                sepratedName.append(firstName)
            }else{
                sepratedName.append("")
            }
            
            if lastName.count > 0 {
                sepratedName.append(lastName)
            }else{
                sepratedName.append("")
            }
        }
        return sepratedName
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //RK
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    //RK
    // regex restrictions for web textfield
    func validateWeb (_ web : String) -> Bool {
        let regex = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2}"
        let range = web.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    func iscontainsOnlyLetters() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isValidString() -> Bool{
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr >= "0" && chr <= "9") && !(chr == "_") && !(chr == "-") && !(chr == ".") && !(chr == "@") && !(chr == ",") && !(chr == " ") && !(chr == "/") ) {
                return false
            }
        }
        return true
    }
    
    //    var length: Int {
    //        return self.characters.count
    //    }
    
    func convertDateFormater() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyyy hh:mma"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let datetemp = dateFormatter.date(from: self)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMMM d, yyyy"
        
        let strNewDate = dateFormatter1.string(from: datetemp!)
        return strNewDate
        
        //
        //        guard let date = dateFormatter.date(from: self) else {
        //            assert(false, "no date from string")
        //            return ""
        //        }
        //
        //        dateFormatter.dateFormat = "MMMM d, yyyy"
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //        let timeStamp = dateFormatter.string(from: date)
        //
        //        return timeStamp
    }
    
    //      func subscripting (i: Int) -> String {
    //            return String( as Character)
    //        }
    
    func stringByAddingPercentEncoding() -> String {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)!
        
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        get {
            if(self.count>=6 && self.count<=20){
                return true
            }else{
                return false
            }
        }
    }
    
    var isValidPhone: Bool {
        get {
            if(self.count>=6 && self.count<=14){
                return true
            }else{
                return false
            }
        }
    }
    
    func removingUrls() -> String {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return self
        }
        return detector.stringByReplacingMatches(in: self,
                                                 options: [],
                                                 range: NSRange(location: 0, length: self.utf16.count),
                                                 withTemplate: "")
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    /// Remove Whitespace from string.
    var removeWhitespace: String {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    /// String decoded from base64  (if applicable).
    var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
    
    /// String encoded in base64 (if applicable).
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = self.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// First character of string (if applicable).
    var firstCharacter: String? {
        return self.map({String($0)}).first
    }
    
    /// Check if string contains one or more letters.
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if string contains only letters.
    var isAlphabetic: Bool {
        return  hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    var isAlphaNumeric: Bool {
        return components(separatedBy: CharacterSet.alphanumerics).joined(separator: "").self.count == 0 && hasLetters && hasNumbers
    }
    
     /// Check URL.
    var URLEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
        return encodedString ?? self
    }
    
    /// Check if string starts with substring.
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func start(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// Check if string ends with substring.
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func end(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// Check if string contains one or more instance of substring.
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contain(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    
    
    func  toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self){
            return date
        }
        print("Invalid arguments ! Returning Current Date . ")
        return Date()
    }
    
//    public var isValidURL: Bool {
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
//            // it is a link, if the match covers the whole string
//            return true
//        } else {
//            return false
//        }
//    }

    /// Check if string is https URL.
    var isHttpsUrl: Bool {
        guard start(with: "https://".lowercased()) else {
            return false
        }
        return URL(string: self) != nil
    }
    
    /// Check if string is http URL.
    var isHttpUrl: Bool {
        guard start(with: "http://".lowercased()) else {
            return false
        }
        return URL(string: self) != nil
    }
    
    /// Check if string contains only numbers.
    var isNumeric: Bool {
        return  !hasLetters && hasNumbers
    }
    
    /// Last character of string (if applicable).
    var lastCharacter: String? {
        guard let last = self.last else {
            return nil
        }
        return String(last)
    }
    
    /// Reversed string.
    var reversed: String {
        return String(self.reversed())
    }
    
    /// Bool value from string (if applicable).
    var bool: Bool? {
        let selfLowercased = self.trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" || selfLowercased == "yes" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" || selfLowercased == "no" {
            return false
        } else {
            return nil
        }
    }
    
    /// Double value from string (if applicable).
    var double: Double? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Double
    }
    
    /// Float value from string (if applicable).
    var float: Float? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Float
    }
    
    /// Float32 value from string (if applicable).
    var float32: Float32? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Float32
    }
    
    /// Float64 value from string (if applicable).
    var float64: Float64? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Float64
    }
    
    /// Integer value from string (if applicable).
    var int: Int? {
        return Int(self)
    }
    
    /// Int16 value from string (if applicable).
    var int16: Int16? {
        return Int16(self)
    }
    
    /// Int32 value from string (if applicable).
    var int32: Int32? {
        return Int32(self)
    }
    
    /// Int64 value from string (if applicable).
    var int64: Int64? {
        return Int64(self)
    }
    
    /// Int8 value from string (if applicable).
    var int8: Int8? {
        return Int8(self)
    }
    
    /// URL from string (if applicable).
    var url: URL? {
        return URL(string: self)
    }
    
    /// String with no spaces or new lines in beginning and end.
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Array with unicodes for all characters in a string.
    var unicodeArray: [Int] {
        return unicodeScalars.map({$0.hashValue})
    }
    
    /// Readable string from a URL string.
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// URL escaped string.
    var encodedURL: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
    
    var EncodeURLForRFC3986: String {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters:allowed as CharacterSet) ?? self
    }
    
    func getWidth(_ height: Double, font: UIFont) -> CGFloat {
        return NSString(string: self).boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: height),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedStringKey.font: font],
                                                     context: nil).size.width
    }
    
    func getHeight(_ width: Double, font: UIFont) -> CGFloat {
        return NSString(string: self).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedStringKey.font: font],
                                                     context: nil).size.height
    }
    
    func getNumberOfLine (_ width: Double, font: UIFont) -> Int {
        let textHeight = NSString(string: self).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   attributes: [NSAttributedStringKey.font: font],
                                                   context: nil).size.height
        
        let characterHeight = font.lineHeight
        let divResult = Int(textHeight) / Int(characterHeight)
        let remainResult = Int(textHeight) % Int(characterHeight)
        var lineCount = 0
        if remainResult > 0 {
            lineCount = divResult + 1
        }else{
            lineCount = divResult
        }
        return lineCount
    }
    
    func getWordsCountFromString() -> Int{
        //var text = "Lorem ..."
        let words = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        // var wordCount: Int = words.count
        return words.count
    }
    
    func getCharactersCountFromString()  -> Int{
        let words = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        // var wordCount: Int = words.count
        var characterCount: Int = 0
        for word: String in words {
            characterCount += word.count
        }
        print(characterCount)
        return characterCount
    }
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , left != right && leftRange.upperBound < rightRange.lowerBound
            else { return nil }
        
        let sub = self.substring(from: leftRange.upperBound)
        let closestToLeftRange = sub.range(of: right)!
        return sub.substring(to: closestToLeftRange.lowerBound)
    }
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    func substring(to : Int) -> String? {
        if (to >= length) {
            return nil
        }
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return self.substring(to: toIndex)
    }
    
    func substring(from : Int) -> String? {
        if (from >= length) {
            return nil
        }
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return self.substring(from: fromIndex)
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex)))
    }
    
    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }
    
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return !unicodeScalars.filter { $0.isEmoji }.isEmpty
    }
    
    var containsOnlyEmoji: Bool {
        return unicodeScalars.first(where: { !$0.isEmoji && !$0.isZeroWidthJoiner }) == nil
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            previousScalar = scalar
        }
        scalars.append(currentScalarSet)
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
            } else if cur.isEmoji {
                chars.append(cur)
            }
            previous = cur
        }
        return chars
    }
    
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
    
    var utfData: Data {
        return Data(utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        
        do {
            return try NSAttributedString(data: utfData,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func htmlAttributedString(size: CGFloat, color: UIColor) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                color: \(color.hexString!);
                font-family: Cairo-Regular;
                font-size: \(size)px;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }

        return attributedString
    }
    
//    var md5: String! {
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        
//        result.deallocate()
//        //result.deallocate(capacity: digestLen)
//        
//        return String(format: hash as String)
//    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    

}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "#%02x%02x%02x", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}
