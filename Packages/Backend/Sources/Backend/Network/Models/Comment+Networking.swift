//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 13/07/2020.
//

import Foundation
import Combine

extension Comment {
    static public func fetch(subreddit: String, id: String) -> AnyPublisher<[ListingResponse<Comment>], Never> {
        API.shared.request(endpoint: .comments(name: subreddit, id: id))
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
