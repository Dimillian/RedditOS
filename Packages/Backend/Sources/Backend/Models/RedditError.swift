//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 22/07/2020.
//

import Foundation
import Combine

public struct RedditError: Decodable {
    public let message: String?
    public let error: Int?
    
    static public func processNetworkError(error: NetworkError) -> RedditError {
        switch error {
        case let .redditAPIError(error, _):
            return error
        default:
            return RedditError(message: "Unknown error", error: -999)
        }
    }
}

