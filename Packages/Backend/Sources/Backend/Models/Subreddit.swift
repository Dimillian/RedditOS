import Foundation

public struct Subreddit: Decodable, Identifiable {
    public let id: String
    public let displayName: String
    public let title: String
    public let publicDescription: String?
    public let primaryColor: String?
    public let keyColor: String?
    public let bannerBackgroundColor: String?
    public let iconImg: String?
    public let bannerImg: String?
    public let subscribers: Int?
}
