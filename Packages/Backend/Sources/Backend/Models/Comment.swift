//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import Foundation

extension ListingResponse where T == Comment {
    public var comments: [Comment] {
        data?.children.map{ $0.data } ?? []
    }
}

public struct Comment: Decodable, Identifiable {
    public let id: String
    public let body: String?
    public let author: String?
    public let created: Date?
    public let createdUtc: Date?
    public let replies: Replies?
    public let score: Int?
    
    public var repliesComments: [Comment]? {
        if let replies = replies {
            switch replies {
            case let .some(replies):
                return replies.data?.children.map{ $0.data }
            default:
                return nil
            }
        }
        return nil
    }
}

public enum Replies: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .some(try container.decode(ListingResponse<Comment>.self))
        } catch {
            self = .none(try container.decode(String.self))
        }
    }
    
    case some(ListingResponse<Comment>)
    case none(String)
}

public let static_comment = Comment(id: UUID().uuidString,
                                    body: "Comment text with a long line of text \n and another line.",
                                    author: "TestUser",
                                    created: Date(),
                                    createdUtc: Date(),
                                    replies: .none(""),
                                    score: 2500)
public let static_comments = [static_comment, static_comment, static_comment]
