//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation

public struct SubredditPost: Decodable, Identifiable, Hashable {
    public static func == (lhs: SubredditPost, rhs: SubredditPost) -> Bool {
        lhs.id == rhs.id && lhs.likes == rhs.likes
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
    public let linkFlairBackgroundColor: String?
    public let linkFlairTextColor: String?
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

public struct SecureMedia: Decodable {
    public let redditVideo: RedditVideo?
    public let oembed: Oembed?
    
    public var video: Video? {
        if let video = redditVideo {
            return Video(url: video.fallbackUrl, width: video.width, height: video.height)
        } else if oembed?.type == "video",
                  let oembed = oembed,
                  let url = oembed.url,
                  let width = oembed.width,
                  let height = oembed.height {
            return Video(url: url, width: width, height: height)
        }
        return nil
    }
}

public struct RedditVideo: Decodable {
    public let fallbackUrl: URL
    public let height: Int
    public let width: Int
}

public struct Oembed: Decodable {
    public let providerUrl: URL?
    public let thumbnailUrl: String?
    public var thumbnailUrlAsURL: URL? {
        thumbnailUrl != nil ? URL(string: thumbnailUrl!) : nil
    }
    public let url: URL?
    public let width: Int?
    public let height: Int?
    public let thumbnailWidth: Int?
    public let thumbnailHeight: Int?
    public let type: String?
}

public struct Video {
    public let url: URL
    public let width: Int
    public let height: Int
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
                                    ups: 1000,
                                    downs: 30,
                                    secureMedia: nil,
                                    url: "https://test.com",
                                    permalink: nil,
                                    linkFlairText: nil,
                                    linkFlairBackgroundColor: nil,
                                    linkFlairTextColor: nil,
                                    visited: false,
                                    saved: false,
                                    likes: nil)
