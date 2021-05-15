import Foundation

public struct Multi: Codable, Identifiable {
    public struct Subreddit: Codable, Identifiable {
        public var id: String {
            name
        }
        public let name: String
    }
    
    public var id: String {
        path
    }
    
    public let displayName: String
    public let iconURL: String?
    public let subreddits: [Subreddit]
    public var subredditsAsName: String {
        return subreddits.map{ $0.name }.joined(separator: "+")
    }
    public let path: String
}
