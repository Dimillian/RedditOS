//
//  UIState.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import Foundation
import SwiftUI
import Combine
import Backend

class UIState: ObservableObject {
    enum Route: Identifiable {
        case user(user: User)
        
        var id: String {
            switch self {
            case .user:
                return "user"
            }
        }
        
        @ViewBuilder
        func makeSheet() -> some View {
            switch self {
            case let .user(user):
                UserSheetView(user: user)
            }
        }
    }
    
    enum DefaultChannels: String, CaseIterable {
        case hot, best, new, top, rising
        
        func icon() -> String {
            switch self {
            case .best: return "rosette"
            case .hot: return "flame"
            case .new: return "calendar.circle"
            case .top: return "chart.bar"
            case .rising: return "waveform.path.ecg"
            }
        }
    }
    
    @Published var selectedPost: SubredditPost?
    @Published var presentedRoute: Route?
    @Published var sidebarSelection: Set<String> = [DefaultChannels.hot.rawValue]
    @Published var searchedSubreddit = ""
    @Published var searchedUser = ""
    @Published var displaySearch = false
}
