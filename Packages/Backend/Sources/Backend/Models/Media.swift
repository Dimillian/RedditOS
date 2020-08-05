//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 05/08/2020.
//

import Foundation

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
