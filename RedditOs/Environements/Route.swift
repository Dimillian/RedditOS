//
//  Route.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 13/08/2020.
//

import Foundation
import SwiftUI
import Combine
import Backend

enum Route: Identifiable, Hashable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case user(user: User, isSheet: Bool)
    case subreddit(subreddit: String, isSheet: Bool)
    case defaultChannel(chanel: UIState.DefaultChannels)
    case none
    
    var id: String {
        switch self {
        case .user:
            return "user"
        case let .subreddit(subreddit, _):
            return subreddit
        case .none:
            return "none"
        case let .defaultChannel(chanel):
            return chanel.rawValue
        }
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case let .user(user, _):
            UserSheetView(user: user)
        case let .subreddit(subreddit, isSheet):
            SubredditPostsListView(name: subreddit, isSheet: isSheet).environmentObject(UIState.shared)
        case let .defaultChannel(chanel):
            SubredditPostsListView(name: chanel.rawValue)
        case .none:
            EmptyView()
        }
    }
}
