import Foundation

public struct SubredditResponse: Decodable {
    public let subreddits: [SubredditSmall]
    
    public init() {
        self.subreddits = []
    }
}

public struct SubredditSmall: Codable, Identifiable, Equatable, Hashable {
    public static func == (lhs: SubredditSmall, rhs: SubredditSmall) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: String { name }
    public let name: String
    public let subscriberCount: Int
    public let activeUserCount: Int
    public let iconImg: String?
    public let keyColor: String?
    
    public static func makeSubredditSmall(with subreddit: Subreddit) -> SubredditSmall {
        SubredditSmall(name: subreddit.displayName,
                       subscriberCount: subreddit.subscribers ?? 0,
                       activeUserCount: subreddit.subscribers ?? 0,
                       iconImg: subreddit.iconImg,
                       keyColor: subreddit.keyColor)
    }
}

public let static_subreddit = SubredditSmall(name: "Games",
                                        subscriberCount: 10000,
                                        activeUserCount: 500,
                                        iconImg: "https://a.thumbs.redditmedia.com/8hr1PTpJ9iWLNWP67vZN0w3IEP8uI3eAQ1kE4XLRg88.png",
                                        keyColor: "#545452")
