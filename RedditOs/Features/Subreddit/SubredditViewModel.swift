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
    let name: String
        
    private var listingPublisher: AnyPublisher<ListingResponse, Never>?
    private var listingCancellable: AnyCancellable?
    
    @Published var listings: [Listing]?
    
    init(name: String) {
        self.name = name
    }
    
    func fetchListings() {
        listingPublisher = API.shared.fetch(endpoint: .subreddit(name: name))
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: ListingResponse(error: "error"))
            .eraseToAnyPublisher()
        listingCancellable = listingPublisher?
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ [weak self] listings in
                self?.listings = listings
            }
         
    }
}
