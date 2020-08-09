import Foundation
import SwiftUI
import Combine

public class CurrentUserStore: ObservableObject, PersistentDataStore {
    
    public static let shared = CurrentUserStore()
    
    @Published public private(set) var user: User? {
        didSet {
            persistData(data: SaveData(user: user,
                                subscriptions: subscriptions))
        }
    }
    
    @Published public private(set) var subscriptions: [Subreddit] = [] {
        didSet {
            persistData(data: SaveData(user: user,
                                subscriptions: subscriptions))
        }
    }
    
    @Published public private(set) var overview: [GenericListingContent]?
    @Published public private(set) var savedPosts: [SubredditPost]?
    @Published public private(set) var submittedPosts: [SubredditPost]?
    
    private var subscriptionFetched = false
    private var fetchingSubscriptions: [Subreddit] = []
    private var disposables: [AnyCancellable?] = []
    private var authStateCancellable: AnyCancellable?
    private var afterOverview: String?
    
    let persistedDataFilename = "CurrentUserData"
    typealias DataType = SaveData
    struct SaveData: Codable {
        let user: User?
        let subscriptions: [Subreddit]
    }
    
    public init() {
        if let data = restorePersistedData() {
            subscriptions = data.subscriptions
            user = data.user
        }
        authStateCancellable = OauthClient.shared.$authState.sink(receiveValue: { state in
            switch state {
            case .signedOut:
                self.user = nil
            case .authenthicated:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.refreshUser()
                    if !self.subscriptionFetched {
                        self.subscriptionFetched = true
                        self.fetchSubscription(after: nil)
                    }
                }
            default:
                break
            }
        })
    }
    
    private func refreshUser() {
        let cancellable = User.fetchMe()?
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
                    let news = subscriptions.map{ $0.data }
                    self.fetchingSubscriptions.append(contentsOf: news)
                }
                if let after = subs.data?.after {
                    self.fetchSubscription(after: after)
                } else {
                    self.fetchingSubscriptions.sort{ $0.displayName.lowercased() < $1.displayName.lowercased() }
                    self.subscriptions = self.fetchingSubscriptions
                    self.fetchingSubscriptions = []
                }
            }
        disposables.append(cancellable)
    }
    
    public func fetchSaved(after: SubredditPost?) {
        let cancellable = user?.fetchSaved(after: after)
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ listings in
                if self.savedPosts?.last != nil, let listings = listings {
                    self.savedPosts?.append(contentsOf: listings)
                } else if self.savedPosts == nil {
                    self.savedPosts = listings
                }
            }
        disposables.append(cancellable)
    }
    
    public func fetchSubmitted(after: SubredditPost?) {
        let cancellable = user?.fetchSubmitted(after: after)
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ listings in
                if self.submittedPosts?.last != nil, let listings = listings {
                    self.submittedPosts?.append(contentsOf: listings)
                } else if self.submittedPosts == nil {
                    self.submittedPosts = listings
                }
            }
        disposables.append(cancellable)
    }
    
    public func fetchOverview() {
        let cancellable = user?.fetchOverview(after: afterOverview)
            .receive(on: DispatchQueue.main)
            .sink{ content in
                self.afterOverview = content.data?.after
                let listings = content.data?.children.map{ $0.data }
                if self.overview?.last != nil, let listings = listings {
                    self.overview?.append(contentsOf: listings)
                } else if self.overview == nil {
                    self.overview = listings
                }
            }
        disposables.append(cancellable)
    }
    
}
