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
    
    static public func fetchAbout(name: String) -> AnyPublisher<ListingHolder<Subreddit>?, Never> {
        API.shared.request(endpoint: .subredditAbout(name: name))
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    public mutating func subscribe() -> AnyPublisher<NetworkResponse, Never> {
        userIsSubscriber = true
        return API.shared.POST(endpoint: .subscribe, params: ["action": "sub", "sr": name])
    }
    
    public mutating func unSubscribe() -> AnyPublisher<NetworkResponse, Never> {
        userIsSubscriber = false
        return API.shared.POST(endpoint: .subscribe, params: ["action": "unsub", "sr": name])
    }
}

