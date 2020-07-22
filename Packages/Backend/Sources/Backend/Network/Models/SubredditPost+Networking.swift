//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 21/07/2020.
//

import Foundation
import Combine

extension SubredditPost {
    public enum Vote: Int {
        case upvote = 1, downvote = -1, neutral = 0
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
}
