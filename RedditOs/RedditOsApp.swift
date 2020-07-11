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
            .frame(minHeight: 400)
            .environmentObject(PersistedContent())
            .environmentObject(OauthClient.shared)
        }
        
        Settings {
            Text("Hello world")
        }
    }
}
