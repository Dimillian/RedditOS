//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation

public struct ListingResponse: Decodable {
    public let kind: String?
    public let data: ListingData?
    public let errorMessage: String?
    
    public init(error: String) {
        self.errorMessage = error
        self.kind = nil
        self.data = nil
    }
}

public struct ListingData: Decodable {
    public let modhash: String
    public let dist: Int
    public let children: [ListingHolder]
}

public struct ListingHolder: Decodable {
    public let kind: String
    public let data: Listing
}

public struct Listing: Decodable, Identifiable {
    public let id: String
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
    public let ups: Int
    public let downs: Int
    public let secureMedia: SecureMedia?
    public let url: String?
}

public struct SecureMedia: Decodable {
    public let redditVideo: RedditVideo?
    public let oembed: Oembed?
    
    public var video: Video? {
        if let video = redditVideo {
            return Video(url: video.fallbackUrl, width: video.width, height: video.height)
        } else if let oembed = oembed,
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
    public let thumbnailUrl: URL?
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

public let static_listing = Listing(id: "0",
                                    title: "A very long title to be able to debug the UI correctly as it should be displayed on mutliple lines.",
                                    numComments: 3400,
                                    subreddit: "preview",
                                    thumbnail: "self",
                                    created: Date(),
                                    createdUtc: Date(),
                                    author: "test",
                                    selftext: "A text",
                                    description: "A description",
                                    ups: 1000,
                                    downs: 30,
                                    secureMedia: nil,
                                    url: "https://test.com")
