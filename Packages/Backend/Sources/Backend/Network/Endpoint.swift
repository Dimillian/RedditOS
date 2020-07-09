import Foundation

public enum Endpoint {
    case subreddit(name: String)
    
    func path() -> String {
        switch self {
        case let .subreddit(name):
            return name
        }
    }
}
