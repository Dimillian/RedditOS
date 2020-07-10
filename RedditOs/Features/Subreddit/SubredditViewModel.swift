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
        
    private var listingPublisher: AnyPublisher<ListingResponse, Never>?
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
        var params: [String: String] = [:]
        if let last = listings?.last {
            params["after"] = "t3_\(last.id)"
        }
        listingPublisher = API.shared.fetch(endpoint: .subreddit(name: name, sort: sortOrder.rawValue),
                                            params: params)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
        listingCancellable = listingPublisher?
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ [weak self] listings in
                if params["after"] != nil, let listings = listings {
                    self?.listings?.append(contentsOf: listings)
                } else if params["after"] == nil {
                    self?.listings = listings
                }
            }
         
    }
}
