//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation

public struct SubredditResponse: Decodable {
    public let subreddits: [Subreddit]
}

public struct Subreddit: Decodable {
    public let name: String
    public let subscriberCount: Int
    public let activeUserCount: Int
    public let iconImg: URL?
    public let keyColor: String?
}
