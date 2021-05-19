//
//  SidebarViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import Foundation
import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable, Equatable {
    case home, account, recentlyVisited, favorites, subscription, multi
    
    var id: String {
        rawValue
    }
    
    func title() -> String {
        switch self {
        case .home:
            return "Home"
        case .account:
            return "Account"
        case .favorites:
            return "Favorites"
        case .recentlyVisited:
            return "Recently Visited"
        case .subscription:
            return "Subscriptions"
        case .multi:
            return "Multireddits"
        }
    }
}
