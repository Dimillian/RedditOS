//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 13/07/2020.
//

import Foundation
import Combine

extension Listing {
    static public func fetch(subreddit: String,
                             sort: String,
                             after: Listing?) -> AnyPublisher<ListingResponse, Never> {
        var params: [String: String] = [:]
        if let listing = after {
            params["after"] = "t3_\(listing.id)"
        }
        return API.shared.request(endpoint: .subreddit(name: subreddit, sort: sort),
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
}
