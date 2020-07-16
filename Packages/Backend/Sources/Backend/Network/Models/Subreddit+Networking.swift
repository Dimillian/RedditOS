import Foundation
import Combine

extension Subreddit {
    static public func fetchMine(after: String?) -> AnyPublisher<ListingResponse<Subreddit>, Never> {
        var params: [String: String] = [:]
        if let after = after {
            params["after"] = after
        }
        params["limit"] = "100"
        return API.shared.request(endpoint: .mineSubscriptions,
                                  params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
    }
}

