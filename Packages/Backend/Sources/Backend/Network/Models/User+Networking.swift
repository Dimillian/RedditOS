//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 24/07/2020.
//

import Foundation
import Combine

extension User {
    static public func fetchMe() -> AnyPublisher<User, NetworkError>? {
        API.shared.request(endpoint: .me).eraseToAnyPublisher()
    }
    
    public func fetchSaved(after: SubredditPost?) -> AnyPublisher<ListingResponse<SubredditPost>, Never> {
        var params: [String: String] = ["type": "links"]
        if let listing = after {
            params["after"] = listing.name
        }
        return API.shared.request(endpoint: .userSaved(username: name),
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
}
