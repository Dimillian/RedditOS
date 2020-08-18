import Foundation

public struct Subreddit: Codable, Identifiable {
    public let id: String
    public let name: String
    public let displayName: String
    public let title: String
    public let publicDescription: String?
    public let primaryColor: String?
    public let keyColor: String?
    public let bannerBackgroundColor: String?
    public let iconImg: String?
    public let bannerImg: String?
    public let subscribers: Int?
    public let accountsActive: Int?
    public let createdUtc: Date
    public let url: String
    public var redditURL: URL {
        URL(string: "https://reddit.com\(url)")!
    }
    public var userIsSubscriber: Bool?
}

public let static_subreddit_full = Subreddit(id: "games",
                                             name: "t3_fjfj",
                                             displayName: "games",
                                             title: "games",
                                             publicDescription: "a description",
                                             primaryColor: "#545452",
                                             keyColor: "#545452",
                                             bannerBackgroundColor: "#545452",
                                             iconImg: "https://a.thumbs.redditmedia.com/8hr1PTpJ9iWLNWP67vZN0w3IEP8uI3eAQ1kE4XLRg88.png",
                                             bannerImg: "https://a.thumbs.redditmedia.com/8hr1PTpJ9iWLNWP67vZN0w3IEP8uI3eAQ1kE4XLRg88.png",
                                             subscribers: 1000,
                                             accountsActive: 500,
                                             createdUtc: Date(),
                                             url: "/r/games",
                                             userIsSubscriber: false)
