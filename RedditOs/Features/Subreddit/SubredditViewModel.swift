//
//  SubredditViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation
import SwiftUI
import Combine
import Backend

class SubredditViewModel: ObservableObject {
    enum SortOrder: String, CaseIterable {
        case hot, new, top, rising
    }
    
    let name: String
        
    @Published var subreddit: Subreddit?
    @Published var listings: [SubredditPost]?
    @Published var searchResults: [SubredditPost]?
    
    @Published var searchText = ""
    @Published var isSearchLoading = false
    
    @AppStorage(SettingsKey.subreddit_defaut_sort_order) var sortOrder = SortOrder.hot {
        didSet {
            listings = nil
            fetchListings(after: nil)
        }
    }
    
    private var postsSearchPublisher: AnyPublisher<ListingResponse<SubredditPost>, Never>?
    private var cancellableSet: Set<AnyCancellable> = Set()
    
    private let localData: LocalDataStore
    
    init(name: String, localData: LocalDataStore = .shared) {
        self.name = name
        self.localData = localData
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap{ $0 }
            .sink(receiveValue: { [weak self] text in
                if text.isEmpty {
                    self?.isSearchLoading = false
                    self?.searchResults = nil
                } else {
                    self?.isSearchLoading = true
                    self?.fetchSearch(text: text, after: nil)
                }
            })
            .store(in: &cancellableSet)
    }
    
    func fetchAbout() {
        Subreddit.fetchAbout(name: name)
           .receive(on: DispatchQueue.main)
            .compactMap{ $0?.data }
           .sink { [weak self] subreddit in
                self?.subreddit = subreddit
                self?.localData.add(recent: SubredditSmall.makeSubredditSmall(with: subreddit))
           }
           .store(in: &cancellableSet)
    }
    
    func fetchListings(after: String?) {
        SubredditPost.fetch(subreddit: name,
                            sort: sortOrder.rawValue,
                            after: after)
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ [weak self] listings in
                if after != nil, let listings = listings {
                    self?.listings?.append(contentsOf: listings)
                } else if self?.listings == nil {
                    self?.listings = listings
                }
            }
            .store(in: &cancellableSet)
    }
    
    func fetchSearch(text: String, after: String?) {
        var params = ["q": text, "restrict_sr": "1"]
        if let after = after {
            params["after"] = after
        }
        postsSearchPublisher = API.shared.request(endpoint: .searchPosts(name: name), params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
        
        postsSearchPublisher?.receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink(receiveValue: { [weak self] results in
                self?.isSearchLoading = false
                if after != nil, let results = results {
                    self?.searchResults?.append(contentsOf: results)
                } else {
                    self?.searchResults = results
                }
            })
            .store(in: &cancellableSet)
    }
    
    func toggleSubscribe() {
        if subreddit?.userIsSubscriber == true {
            subreddit?.unSubscribe()
               .receive(on: DispatchQueue.main)
               .sink { [weak self] response in
                   if response.error != nil {
                       self?.subreddit?.userIsSubscriber = true
                   }
               }
               .store(in: &cancellableSet)
        } else {
            subreddit?.subscribe()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] response in
                    if response.error != nil {
                        self?.subreddit?.userIsSubscriber = false
                    }
                }
                .store(in: &cancellableSet)
        }
    }
}
