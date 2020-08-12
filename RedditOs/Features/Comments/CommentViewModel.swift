//
//  CommentViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 12/08/2020.
//

import Foundation
import SwiftUI
import Combine
import Backend

class CommentViewModel: ObservableObject {
    @Published var comment: Comment
    
    private var cancellableStore: [AnyCancellable] = []
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func postVote(vote: Vote) {
        let oldValue = comment.likes
        let cancellable = comment.vote(vote: vote)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] response in
                if response.error != nil {
                    self?.comment.likes = oldValue
                }
            }
        cancellableStore.append(cancellable)
    }
    
    func toggleSave() {
        let oldValue = comment.saved
        let cancellable = (comment.saved == true ? comment.unsave() : comment.save())
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] response in
                if response.error != nil {
                    self?.comment.saved = oldValue
                }
            }
        cancellableStore.append(cancellable)
    }
    
}
