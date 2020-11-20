//
//  IPaDisplayHtml.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/10/26.
//

import Foundation

protocol IPaDisplayHtml {
    func replaceCSSPtToPx(with string:String) -> String
}
extension IPaDisplayHtml {
    func replaceCSSPtToPx(with string:String) -> String {
        guard let regex = try? NSRegularExpression(pattern: "(\\d+)pt", options:  NSRegularExpression.Options()) else {
            return string
        }
        let newString = regex.stringByReplacingMatches(in: string, options: [], range: NSRange(string.startIndex..., in:string), withTemplate: "$1px")
        
        
        return newString
    }
}
