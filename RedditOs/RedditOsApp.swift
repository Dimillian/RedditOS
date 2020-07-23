//
//  RedditOsApp.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import AppKit
import SwiftUI
import Backend

class AppDelegateAdaptor: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        if let url = urls.first {
            OauthClient.shared.handleNextURL(url: url)
        }
    }
}


@main
struct RedditOsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    
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
            .frame(minHeight: 400, idealHeight: 800)
            .environmentObject(PersistedContent())
            .environmentObject(OauthClient.shared)
            .environmentObject(CurrentUser())
        }.commands{
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
