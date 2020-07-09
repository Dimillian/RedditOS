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
        case best, hot, new, top, rising
        
        func icon() -> String {
            switch self {
            case .best: return "airplane"
            case .hot: return "flame.fill"
            case .new: return "calendar.circle"
            case .top: return "chart.bar.fill"
            case .rising: return "waveform.path.ecg"
            }
        }
    }
    
    @Published var selection: Set<String> = [MainSubreddits.best.rawValue]
}
