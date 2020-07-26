import Foundation

public struct ListingResponse<T: Decodable>: Decodable {
    public let kind: String?
    public let data: ListingData<T>?
    public let errorMessage: String?
    
    public init(error: String) {
        self.errorMessage = error
        self.kind = nil
        self.data = nil
    }
}

public struct ListingData<T: Decodable>: Decodable {
    public let modhash: String?
    public let dist: Int?
    public let after: String?
    public let before: String?
    public let children: [ListingHolder<T>]
}

public struct ListingHolder<T: Decodable>: Decodable {
    public let kind: String
    public let data: T
    
    enum CodingKeys : CodingKey {
        case kind, data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(String.self, forKey: .kind)
        if T.self == GenericListingContent.self {
            data = try GenericListingContent(from: decoder) as! T
        } else {
            data = try container.decode(T.self, forKey: .data)
        }
    }
}

public enum GenericListingContent: Decodable, Identifiable {
    public var id: String {
        switch self {
        case let .post(post):
            return post.id
        case let .comment(comment):
            return comment.id
        default:
            return UUID().uuidString
        }
    }
    
    public var post: SubredditPost? {
        if case .post(let post) = self {
            return post
        }
        return nil
    }
    
    public var comment: Comment? {
        if case .comment(let comment) = self {
            return comment
        }
        return nil
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ListingHolder<GenericListingContent>.CodingKeys.self)
        let kind = try container.decode(String.self, forKey: .kind)
        switch kind {
        case "t1":
            self = .comment(try container.decode(Comment.self, forKey: .data))
        case "t3":
            self = .post(try container.decode(SubredditPost.self, forKey: .data))
        default:
            self = .notSupported
        }
    }
    
    case post(SubredditPost)
    case comment(Comment)
    case notSupported
}

