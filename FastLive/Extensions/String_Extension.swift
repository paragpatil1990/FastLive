//
//  String_Extension.swift
//  Wahed
//
//  Created by Amrit Singh on 3/23/17.
//  Copyright © 2017 InfoManav. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
        
        var html2AttributedString: NSAttributedString? {
            guard
                let data = data(using: String.Encoding.utf8)
                else { return nil }
            do {
                let attrs: [String: Any] = [
                    NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
                ]
                return try NSAttributedString(data: data, options: attrs, documentAttributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                return  nil
            }
        }
        var html2String: String {
            return html2AttributedString?.string ?? ""
        }
    
    
    var detectDates: [Date]? {
        do {
            return try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
                .matches(in: self, options: [], range: NSRange(location: 0, length: (self as NSString).length))
                .flatMap{$0.date}
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
        var isNumber : Bool {
            get{
                return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            }
        }

}


extension Collection where Iterator.Element == String
{
    var dates: [Date] {
        return flatMap{$0.detectDates}.flatMap{$0}
    }
}
