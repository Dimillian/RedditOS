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
    
    enum Constants {
        static let searchTag = "search"
    }
        
    @Published var displayToolbarSearchBar = true
    
    @Published var selectedSubreddit: SubredditViewModel?
    @Published var selectedPost: PostViewModel?
    
    @Published var presentedSheetRoute: Route?
    @Published var searchRoute: Route? {
        didSet {
            if searchRoute != nil {
                sidebarSelection = Constants.searchTag
                displayToolbarSearchBar = false
            }
        }
    }
    
    lazy var isSearchActive: Binding<Bool> = .init(get: {
        self.sidebarSelection == Constants.searchTag
    }, set: { _ in })
    
    @Published var sidebarSelection: String? = DefaultChannels.hot.rawValue {
        didSet {
            if sidebarSelection != Constants.searchTag {
                searchRoute = nil
                displayToolbarSearchBar = true
            } else {
                displayToolbarSearchBar = false
            }
        }
    }
}
