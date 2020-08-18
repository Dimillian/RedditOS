//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation

public struct SubredditPost: Decodable, Identifiable, Hashable {
    public static func == (lhs: SubredditPost, rhs: SubredditPost) -> Bool {
        lhs.id == rhs.id &&
            lhs.likes == rhs.likes &&
            lhs.saved == rhs.saved
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public let id: String
    public let name: String
    public let title: String
    public let numComments: Int
    public let subreddit: String
    public let thumbnail: String
    public let created: Date
    public let createdUtc: Date
    public var thumbnailURL: URL? {
        guard thumbnail.hasPrefix("http"),
              let url = URL(string: thumbnail) else {
            return nil
        }
        return url
    }
    public let author: String
    public let selftext: String?
    public let description: String?
    public var ups: Int
    public let downs: Int
    public let secureMedia: SecureMedia?
    public let url: String?
    public let permalink: String?
    
    public let linkFlairText: String?
    public let linkFlairRichtext: [FlairRichText]?
    public let linkFlairBackgroundColor: String?
    public let linkFlairTextColor: String?
    
    public let authorFlairRichtext: [FlairRichText]?
    public let authorFlairText: String?
    public let authorFlairTextColor: String?
    public let authorFlairBackgroundColor: String?
    
    public let allAwardings: [Award]
    public var visited: Bool
    public var saved: Bool
    public var redditURL: URL? {
        if let permalink = permalink, let url = URL(string: "https://reddit.com\(permalink)") {
            return url
        }
        return nil
    }
    public var likes: Bool?
}

public let static_listing = SubredditPost(id: "0",
                                          name: "t3_0",
                                    title: "A very long title to be able to debug the UI correctly as it should be displayed on mutliple lines.",
                                    numComments: 3400,
                                    subreddit: "preview",
                                    thumbnail: "",
                                    created: Date(),
                                    createdUtc: Date(),
                                    author: "TestUser",
                                    selftext: "A text",
                                    description: "A description",
                                    ups: 150 * 1000,
                                    downs: 30,
                                    secureMedia: nil,
                                    url: "https://test.com",
                                    permalink: nil,
                                    linkFlairText: nil,
                                    linkFlairRichtext: nil,
                                    linkFlairBackgroundColor: nil,
                                    linkFlairTextColor: nil,
                                    authorFlairRichtext: nil,
                                    authorFlairText: nil,
                                    authorFlairTextColor: nil,
                                    authorFlairBackgroundColor: nil,
                                    allAwardings: [],
                                    visited: false,
                                    saved: false,
                                    likes: nil)
