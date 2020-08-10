//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 10/08/2020.
//

import Foundation

public struct FlairRichText: Decodable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(e)
        hasher.combine(u)
        hasher.combine(t)
    }
    
    /// type
    public let e: String
    /// image URL
    public let u: URL?
    /// text
    public let t: String?
}
