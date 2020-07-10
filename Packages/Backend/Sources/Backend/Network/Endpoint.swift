import Foundation

public enum Endpoint {
    case subreddit(name: String, sort: String?)
    case searchSubreddit
    
    func path() -> String {
        switch self {
        case let .subreddit(name, sort):
            if name == "top" || name == "best" || name == "new" || name == "rising" || name == "hot" {
                return name
            } else if let sort = sort {
                return "r/\(name)/\(sort)"
            } else {
                return "r/\(name)"
            }
        case .searchSubreddit:
            return "api/search_subreddits"
        }
    }
}
