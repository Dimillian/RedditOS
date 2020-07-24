//
//  RedditOsApp.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import AppKit
import SwiftUI
import Backend

@main
struct RedditOsApp: App {
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar()
            }
            .frame(minHeight: 400, idealHeight: 800)
            .environmentObject(LocalDataStore())
            .environmentObject(OauthClient.shared)
            .environmentObject(CurrentUserStore())
            .onOpenURL { url in
                OauthClient.shared.handleNextURL(url: url)
            }
        }
        .commands{
            CommandMenu("Subreddit") {
                Button(action: {
                    
                }) {
                    Text("Seach")
                }.keyboardShortcut("f", modifiers: .command)
                Button(action: {
                    
                }) {
                    Text("Navigate to")
                }
                Divider()
                Button(action: {
                    
                }) {
                    Text("Favorite")
                }
            }
        }
        
        Settings {
            Text("Hello world")
        }
    }
}
