//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import Foundation

public struct CommentsRoot: Decodable {
    public let kind: String
    public let data: CommentData
    
    public var comments: [Comment] {
        data.children.map{ $0.data }
    }
}

public struct CommentData: Decodable {
    public let after: String?
    public let before: String?
    public let dist: Int?
    public let children: [CommentChildrenTop]
}

public struct CommentChildrenTop: Decodable {
    public let kind: String
    public let data: Comment
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
                return replies.data.children.map{ $0.data }
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
            self = .some(try container.decode(CommentsRoot.self))
        } catch {
            self = .none(try container.decode(String.self))
        }
    }
    
    case some(CommentsRoot)
    case none(String)
}

public let static_comment = Comment(id: "1", body: "Comment text",
                                    author: "user", created: Date(), createdUtc: Date(), replies: .none(""), score: 2500)
public let static_comments = [static_comment, static_comment, static_comment]
