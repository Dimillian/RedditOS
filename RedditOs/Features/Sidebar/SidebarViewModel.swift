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
        case hot, best, new, top, rising
        
        func icon() -> String {
            switch self {
            case .best: return "sun.max"
            case .hot: return "flame"
            case .new: return "calendar.circle"
            case .top: return "chart.bar"
            case .rising: return "waveform.path.ecg"
            }
        }
    }
    
    @Published var selection: Set<String> = [MainSubreddits.hot.rawValue]
}
