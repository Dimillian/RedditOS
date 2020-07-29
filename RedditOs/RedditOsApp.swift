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
    @StateObject private var uiState = UIState()
    
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
            .environmentObject(uiState)
            .onOpenURL { url in
                OauthClient.shared.handleNextURL(url: url)
            }
            .sheet(item: $uiState.presentedRoute, content: { $0.makeSheet() })
        }
        .commands{
            CommandMenu("Subreddit") {
                Button(action: {
                    
                }) {
                    Text("Search")
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
            
            #if DEBUG
            CommandMenu("Debug") {
                Button(action: {
                    switch OauthClient.shared.authState {
                    case let .authenthicated(token):
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(token, forType: .string)
                    default:
                        break
                    }
                }) {
                    Text("Copy oauth token to pasteboard")
                }
            }
            #endif
        }
        
        Settings {
            Text("Hello world")
        }
    }
}
