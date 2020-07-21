//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 21/07/2020.
//

import Foundation

extension SubredditPost {
    public enum Vote: Int {
        case upvote = 1, downvote = -1, neutral = 0
    }
    
    public mutating func vote(vote: Vote) {
        switch vote {
        case .upvote:
            likes = true
        case .downvote:
            likes = false
        case .neutral:
            likes = nil
        }
    }
}
