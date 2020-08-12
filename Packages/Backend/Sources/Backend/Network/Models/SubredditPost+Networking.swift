//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 21/07/2020.
//

import Foundation
import Combine

extension SubredditPost {    
    static public func fetch(subreddit: String,
                             sort: String,
                             after: SubredditPost?) -> AnyPublisher<ListingResponse<SubredditPost>, Never> {
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
    
    public mutating func vote(vote: Vote) -> AnyPublisher<NetworkResponse, Never> {
        switch vote {
        case .upvote:
            likes = true
            ups += 1
        case .downvote:
            likes = false
            ups -= 1
        case .neutral:
            if likes == true {
                ups -= 1
            } else if likes == false {
                ups += 1
            }
            likes = nil
        }
        return API.shared.POST(endpoint: .vote,
                               params: ["id": name, "dir": "\(vote.rawValue)"])
    }
    
    public mutating func visit() -> AnyPublisher<NetworkResponse, Never> {
        visited = true
        return API.shared.POST(endpoint: .visits, params: ["links": name])
    }
    
    public mutating func save() -> AnyPublisher<NetworkResponse, Never> {
        saved = true
        return API.shared.POST(endpoint: .save, params: ["id": name])
    }
    
    public mutating func unsave() -> AnyPublisher<NetworkResponse, Never> {
        saved = false
        return API.shared.POST(endpoint: .unsave, params: ["id": name])
    }
}
