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
            return NSLocalizedString("Home",
                                     comment: "Sidebar item - navigates back to the Home screen")
        case .account:
            return NSLocalizedString("Account",
                                     comment: "Sidebar item - navigates to the Account screen")
        case .favorites:
            return NSLocalizedString("Favorites",
                                     comment: "Sidebar item - navigates to the Favorites screen")
        case .recentlyVisited:
            return NSLocalizedString("Recently Visited",
                                     comment: "Sidebar item - navigates to Recently Visited screen")
        case .subscription:
            return NSLocalizedString("Subscriptions",
                                     comment: "Sidebar item - navigates to the Subscriptions screen")
        case .multi:
            return "Multireddits" // VERBATIM, no localization
        }
    }
}
