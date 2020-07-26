//
//  UserViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import Foundation
import Backend
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    let username: String
    
    @Published var user: User?
    @Published public private(set) var overview: [GenericListingContent]?
    @Published public private(set) var submittedPosts: [SubredditPost]?
    @Published public private(set) var comments: [Comment]?
    
    private var cancellable: AnyCancellable?
    private var disposables: [AnyCancellable?] = []
    private var afterOverview: String?
    
    init(username: String) {
        self.username = username
        fetchUser()
    }
    
    init(user: User) {
        self.username = user.name
        self.user = user
        
        fetchOverview()
        fetchSubmitted(after: nil)
        fetchComment(after: nil)
    }
    
    func fetchUser() {
        cancellable = User.fetchUserAbout(username: username)?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { data in
                self.user = data.data
            })
    }
    
    func fetchOverview() {
        let cancellable = user?.fetchOverview(after: afterOverview)
            .receive(on: DispatchQueue.main)
            .sink{ content in
                self.afterOverview = content.data?.after
                let listings = content.data?.children.map{ $0.data }
                if self.overview?.last != nil, let listings = listings {
                    self.overview?.append(contentsOf: listings)
                } else if self.overview == nil {
                    self.overview = listings
                }
            }
        disposables.append(cancellable)
    }
    
    public func fetchSubmitted(after: SubredditPost?) {
        let cancellable = user?.fetchSubmitted(after: after)
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ listings in
                if self.submittedPosts?.last != nil, let listings = listings {
                    self.submittedPosts?.append(contentsOf: listings)
                } else if self.submittedPosts == nil {
                    self.submittedPosts = listings
                }
            }
        disposables.append(cancellable)
    }
    
    public func fetchComment(after: Comment?) {
        let cancellable = user?.fetchComments(after: after)
            .receive(on: DispatchQueue.main)
            .map{ $0.data?.children.map{ $0.data }}
            .sink{ listings in
                if self.comments?.last != nil, let listings = listings {
                    self.comments?.append(contentsOf: listings)
                } else if self.comments == nil {
                    self.comments = listings
                }
            }
        disposables.append(cancellable)
    }
}
