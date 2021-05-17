//
//  SearchSubredditsViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation
import SwiftUI
import Combine
import Backend

class QuickSearchState: ObservableObject {
    @Published var searchText = ""
    @Published var results: [SubredditSmall]?
    @Published var postResults: [SubredditPost]?
    @Published var filteredSubscriptions: [Subreddit]?
    @Published var trending: TrendingSubreddits?
    @Published var isLoading = false
    
    private var currentUser: CurrentUserStore
    
    private var subredditSearchPublisher: AnyPublisher<SubredditResponse, Never>?
    private var postSearchPublisher: AnyPublisher<ListingResponse<SubredditPost>, Never>?
    private var cancellableSet: Set<AnyCancellable> = Set()
    private var searchCancellable: AnyCancellable?
    
    init(currentUser: CurrentUserStore = .shared) {
        self.currentUser = currentUser
        
        $searchText
            .subscribe(on: DispatchQueue.global())
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                if text.isEmpty {
                    self?.isLoading = false
                    self?.results = nil
                } else {
                    self?.isLoading = true
                    self?.search(with: text)
                }
            })
            .store(in: &cancellableSet)
        
        $searchText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let w = self else { return }
                if text.isEmpty {
                    w.filteredSubscriptions = nil
                } else {
                    w.filteredSubscriptions = w.currentUser.subscriptions.filter{ $0.displayName.lowercased().contains(text.lowercased()) }
                }
            })
            .store(in: &cancellableSet)
    }
    
    private func search(with text: String) {
        searchCancellable?.cancel()
                
        subredditSearchPublisher = API.shared.request(endpoint: .searchSubreddit, httpMethod: "POST", params: ["query": text])
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: SubredditResponse())
            .eraseToAnyPublisher()
        
        postSearchPublisher = API.shared.request(endpoint: .search, params: ["q": text])
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
        
        searchCancellable = Publishers.Zip(subredditSearchPublisher!,
                                           postSearchPublisher!)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] subreddits, posts in
                self?.results = subreddits.subreddits.map{ $0 }
                self?.postResults = posts.data?.children.map{ $0.data }
                self?.isLoading = false
            })
        
    }
    
    public func fetchTrending() {
        TrendingSubreddits.fetch()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trending in
                self?.trending = trending
            }
            .store(in: &cancellableSet)
    }
}
