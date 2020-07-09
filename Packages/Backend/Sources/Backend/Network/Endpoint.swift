import Foundation

public enum Endpoint {
    case subreddit(name: String)
    case searchSubreddit
    
    func path() -> String {
        switch self {
        case let .subreddit(name):
            return name
        case .searchSubreddit:
            return "api/search_subreddits"
        }
    }
}
