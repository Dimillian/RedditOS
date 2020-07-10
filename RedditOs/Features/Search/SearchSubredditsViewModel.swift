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

class SearchSubredditsViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var results: [Subreddit]?
    @Published var isLoading = false
    
    private var searchCancellable: AnyCancellable?
    private var apiPublisher: AnyPublisher<SubredditResponse, Never>?
    private var apiCancellable: AnyCancellable?
    
    init() {
        searchCancellable = $searchText
            .subscribe(on: DispatchQueue.global())
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                self?.isLoading = true
                self?.search(with: text)
            })
    }
    
    private func search(with text: String) {
        apiCancellable?.cancel()
        let param = ["query": text]
        apiPublisher = API.shared.fetch(endpoint: .searchSubreddit, httpMethod: "POST", params: param)
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
