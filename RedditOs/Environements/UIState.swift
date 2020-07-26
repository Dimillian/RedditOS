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
    
    @Published var presentedRoute: Route?
}
