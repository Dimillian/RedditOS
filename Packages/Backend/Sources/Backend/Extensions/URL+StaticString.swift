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
    init(staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            fatalError("URL is illegal: \(staticString)")
        }
        self = url
    }
}
