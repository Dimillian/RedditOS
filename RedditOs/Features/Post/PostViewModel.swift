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

class PostViewModel: ObservableObject {
    @Published var post: SubredditPost
    @Published var comments: [Comment]?
    
    private var commentsCancellable: AnyCancellable?
    
    init(post: SubredditPost) {
        self.post = post
    }
    
    func fechComments() {
        commentsCancellable = Comment.fetch(subreddit: post.subreddit, id: post.id)
            .receive(on: DispatchQueue.main)
            .map{ $0.last?.comments }
            .sink{ [weak self] comments in
                self?.comments = comments
            }
    }
}
