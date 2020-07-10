//
//  RedditOsApp.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI
import Backend

@main
struct RedditOsApp: App {
    
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar()
                Text("Select a post")
                    .frame(minWidth: 250,
                           maxWidth: .infinity,
                           maxHeight: .infinity)
            }
            .frame(minHeight: 400)
            .environmentObject(PersistedContent())
        }
        
        Settings {
            Text("Hello world")
        }
    }
}
