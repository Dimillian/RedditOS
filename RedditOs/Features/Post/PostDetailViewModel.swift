//
//  PostDetailViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import Foundation
import SwiftUI
import Combine
import Backend

class PostDetailViewModel: ObservableObject {
    let listing: Listing
    @Published var comments: [Comment]?
    
    private var commentsPublisher: AnyPublisher<[CommentsRoot], Never>?
    private var commentsCancellable: AnyCancellable?
    
    init(listing: Listing) {
        self.listing = listing
    }
    
    func fechComments() {
        commentsPublisher = API.shared.fetch(endpoint: .comments(name: listing.subreddit, id: listing.id))
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [])
            .eraseToAnyPublisher()
        commentsCancellable = commentsPublisher?
            .receive(on: DispatchQueue.main)
            .map{ $0.last?.comments }
            .sink{ [weak self] comments in
                self?.comments = comments
            }
    }
}
