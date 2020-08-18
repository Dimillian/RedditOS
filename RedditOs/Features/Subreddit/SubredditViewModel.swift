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
    
    private var subredditCancellable: AnyCancellable?
    private var listingCancellable: AnyCancellable?
    private var subscribeCancellable: AnyCancellable?
    
    @Published var subreddit: Subreddit?
    @Published var listings: [SubredditPost]?
    @AppStorage(SettingsKey.subreddit_defaut_sort_order) var sortOrder = SortOrder.hot {
        didSet {
            listings = nil
            fetchListings()
        }
    }
    @Published var errorLoadingAbout = false
    
    init(name: String) {
        self.name = name
    }
    
    func fetchAbout() {
        subredditCancellable = Subreddit.fetchAbout(name: name)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] holder in
                self?.errorLoadingAbout = holder == nil
                self?.subreddit = holder?.data
            }
    }
    
    func fetchListings() {
        listingCancellable = SubredditPost.fetch(subreddit: name,
                                           sort: sortOrder.rawValue,
                                           after: listings?.last)
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ [weak self] listings in
                if self?.listings?.last != nil, let listings = listings {
                    self?.listings?.append(contentsOf: listings)
                } else if self?.listings == nil {
                    self?.listings = listings
                }
            }
    }
    
    func toggleSubscribe() {
        if subreddit?.userIsSubscriber == true {
            subscribeCancellable = subreddit?.unSubscribe()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] response in
                    if response.error != nil {
                        self?.subreddit?.userIsSubscriber = true
                    }
                }
        } else {
            subscribeCancellable = subreddit?.subscribe()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] response in
                    if response.error != nil {
                        self?.subreddit?.userIsSubscriber = false
                    }
                }
        }
    }
}
