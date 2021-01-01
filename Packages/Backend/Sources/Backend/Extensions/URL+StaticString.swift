//
//  URL+StaticString.swift
//  
//
//  Created by Dan Korkelia on 01/01/2021.
//

import Foundation

extension URL {
    /// Use this init for static URL strings to avoid using force unwrap or doing redundant error handling
    /// - Parameter string: static url ie https://www.example.com/privacy/
    init(_ string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            fatalError("URL is illegal: \(string)")
        }
        self = url
    }
}
