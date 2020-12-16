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
    public static let shared = UIState()
    
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
    
    private init() {
        
    }
    
    @Published var selectedSubreddit: SubredditViewModel?
    @Published var selectedPost: PostViewModel?
    
    @Published var presentedSheetRoute: Route?
    @Published var presentedNavigationRoute: Route? {
        didSet {
            if let route = presentedNavigationRoute {
                sidebarSelection = route.id
            }
        }
    }
    
    @Published var sidebarSelection: String? = DefaultChannels.hot.rawValue
}
