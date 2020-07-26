//
//  UserPopoverViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import Foundation
import Backend
import Combine
import SwiftUI

class UserPopoverViewModel: ObservableObject {
    private let username: String
    @Published var user: User?
    
    private var cancellable: AnyCancellable?
    
    init(username: String) {
        self.username = username
        fetchUser()
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
}
