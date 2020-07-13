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
    
    private var listingCancellable: AnyCancellable?
    
    @Published var listings: [Listing]?
    @Published var sortOrder = SortOrder.hot {
        didSet {
            listings = nil
            fetchListings()
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
    func fetchListings() {
        listingCancellable = Listing.fetch(subreddit: name,
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
}
