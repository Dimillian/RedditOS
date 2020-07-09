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
    public var thumbnailURL: URL? {
        guard let url = URL(string: thumbnail) else {
            return nil
        }
        return url
    }
    public let author: String
    public let selftext: String
    public let ups: Int
    public let downs: Int
}

public let static_listing = Listing(id: "0",
                                    title: "A sample post",
                                    numComments: 3400,
                                    subreddit: "preview",
                                    thumbnail: "self",
                                    created: Date(),
                                    author: "test",
                                    selftext: "",
                                    ups: 1000,
                                    downs: 30)
