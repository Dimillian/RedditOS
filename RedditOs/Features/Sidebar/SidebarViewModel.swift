//
//  SidebarViewModel.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation
import SwiftUI

class SidebarViewModel: ObservableObject {
    enum MainSubreddits: String, CaseIterable {
        case best, hot, new, top
        
        func icon() -> String {
            switch self {
            case .best: return "airplane"
            case .hot: return "flame.fill"
            case .new: return "calendar.circle"
            case .top: return "chart.bar.fill"
            }
        }
    }
    
    @Published var selection: Set<String> = [MainSubreddits.best.rawValue]
}
