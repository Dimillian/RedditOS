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
    let listing: SubredditPost
    @Published var comments: [Comment]?
    
    private var commentsCancellable: AnyCancellable?
    
    init(listing: SubredditPost) {
        self.listing = listing
    }
    
    func fechComments() {
        commentsCancellable = Comment.fetch(subreddit: listing.subreddit, id: listing.id)
            .receive(on: DispatchQueue.main)
            .map{ $0.last?.comments }
            .sink{ [weak self] comments in
                self?.comments = comments
            }
    }
}
