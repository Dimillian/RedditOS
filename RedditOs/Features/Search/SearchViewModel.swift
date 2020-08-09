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

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var results: [SubredditSmall]?
    @Published var filteredSubscriptions: [Subreddit]?
    @Published var isLoading = false
    
    private var currentUser: CurrentUserStore
    
    private var delayedSearchCancellable: AnyCancellable?
    private var instantSearchCancellable: AnyCancellable?
    private var apiPublisher: AnyPublisher<SubredditResponse, Never>?
    private var apiCancellable: AnyCancellable?
    
    init(currentUser: CurrentUserStore = .shared) {
        self.currentUser = currentUser
        
        delayedSearchCancellable = $searchText
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
        
        instantSearchCancellable = $searchText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let w = self else { return }
                if text.isEmpty {
                    w.filteredSubscriptions = nil
                } else {
                    w.filteredSubscriptions = w.currentUser.subscriptions.filter{ $0.displayName.lowercased().contains(text.lowercased()) }
                }
            })
    }
    
    private func search(with text: String) {
        apiCancellable?.cancel()
        let param = ["query": text]
        apiPublisher = API.shared.request(endpoint: .searchSubreddit, httpMethod: "POST", params: param)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: SubredditResponse())
            .eraseToAnyPublisher()
        apiCancellable = apiPublisher?
            .receive(on: DispatchQueue.main)
            .map{ $0.subreddits }
            .sink{ [weak self] results in
                self?.isLoading = false
                self?.results = results
            }
        
    }
}
