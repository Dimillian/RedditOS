import Foundation
import SwiftUI
import Combine

public class CurrentUser: ObservableObject {
    @Published public var user: User?
    @Published public var subscriptions: [Subreddit] = []
    
    private var subscriptionFetched = false
    private var disposables: [AnyCancellable?] = []
    private var authStateCancellable: AnyCancellable?
    
    public init() {
        authStateCancellable = OauthClient.shared.$authState.sink(receiveValue: { state in
            switch state {
            case .signedOut:
                self.user = nil
            case .authenthicated:
                self.refreshUser()
                if !self.subscriptionFetched {
                    self.subscriptionFetched = true
                    self.fetchSubscription(after: nil)
                }
            default:
                break
            }
        })
    }
    
    private func refreshUser() {
        let cancellable = makeUserPublisher()?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { user in
                self.user = user
            })
        disposables.append(cancellable)
    }
    
    private func fetchSubscription(after: String?) {
        let cancellable = Subreddit.fetchMine(after: after)
            .receive(on: DispatchQueue.main)
            .sink { subs in
                if let subscriptions = subs.data?.children {
                    var news = subscriptions.map{ $0.data }
                    news.sort{ $0.displayName.lowercased() < $1.displayName.lowercased() }
                    self.subscriptions.append(contentsOf: news)
                }
                if let after = subs.data?.after {
                    self.fetchSubscription(after: after)
                }
            }
        disposables.append(cancellable)
    }
    
    private func makeUserPublisher() -> AnyPublisher<User, APIError>? {
        return API.shared.request(endpoint: .me).eraseToAnyPublisher()
    }
}
