//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 13/07/2020.
//

import Foundation
import Combine

extension Comment {
    public enum Sort: String, CaseIterable {
        case best = "confidence"
        case top, new, controversial, old, qa
    }
    
    static public func fetch(subreddit: String, id: String, sort: Sort = .top) -> AnyPublisher<[ListingResponse<Comment>], Never> {
        let params: [String: String] = ["sort": sort.rawValue]
        return API.shared.request(endpoint: .comments(name: subreddit, id: id), params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    public mutating func vote(vote: Vote) -> AnyPublisher<NetworkResponse, Never> {
        switch vote {
        case .upvote:
            likes = true
        case .downvote:
            likes = false
        case .neutral:
            likes = nil
        }
        return API.shared.POST(endpoint: .vote,
                               params: ["id": name, "dir": "\(vote.rawValue)"])
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
