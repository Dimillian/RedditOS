import Foundation
import Combine

extension TrendingSubreddits {
    public static func fetch() -> AnyPublisher<TrendingSubreddits, Never> {
        API.shared.request(endpoint: .trendingSubreddits, forceSignedOutURL: true)
            .subscribe(on: DispatchQueue.global())
            .catch { _ in Empty(completeImmediately: false) }
            .eraseToAnyPublisher()
    }
}
