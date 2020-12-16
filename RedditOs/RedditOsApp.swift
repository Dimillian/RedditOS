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
    @StateObject private var uiState = UIState.shared
    @StateObject private var localData = LocalDataStore()
    
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SidebarView()
            }
            .frame(minWidth: 1300, minHeight: 800)
            .environmentObject(localData)
            .environmentObject(OauthClient.shared)
            .environmentObject(CurrentUserStore.shared)
            .environmentObject(uiState)
            .onOpenURL { url in
                OauthClient.shared.handleNextURL(url: url)
            }
            .sheet(item: $uiState.presentedSheetRoute, content: { $0.makeView() })
        }
        .commands {
            CommandMenu("Subreddit") {
                Button(action: {
                    uiState.selectedSubreddit?.listings = nil
                    uiState.selectedSubreddit?.fetchListings()
                }) {
                    Text("Refresh")
                }
                .disabled(uiState.selectedSubreddit != nil)
                .keyboardShortcut("r", modifiers: [.command])
                
                Divider()
                
                Button(action: {
                    if let subreddit = uiState.selectedSubreddit?.subreddit {
                        let small = SubredditSmall.makeSubredditSmall(with: subreddit)
                        if localData.favorites.contains(small) {
                            localData.remove(favorite: small)
                        } else {
                            localData.add(favorite: small)
                        }
                    }

                }) {
                    Text("Toggle favorite")
                }
                .disabled(uiState.selectedSubreddit != nil)
                .keyboardShortcut("f", modifiers: [.command, .shift])
            }
            
            CommandMenu("Post") {
                Button(action: {
                    uiState.selectedPost?.fechComments()
                }) {
                    Text("Refresh comments")
                }
                .disabled(uiState.selectedPost != nil)
                .keyboardShortcut("r", modifiers: [.command, .shift])
                
                Button(action: {
                    uiState.selectedPost?.toggleSave()
                }) {
                    Text(uiState.selectedPost?.post.saved == true ? "Unsave" : "Save")
                }
                .disabled(uiState.selectedPost != nil)
                .keyboardShortcut("s", modifiers: .command)
                
                Divider()
                Button(action: {
                    uiState.selectedPost?.postVote(vote: .upvote)
                }) {
                    Text("Upvote")
                }
                .disabled(uiState.selectedPost != nil)
                .keyboardShortcut(.upArrow, modifiers: .shift)
                
                Button(action: {
                    uiState.selectedPost?.postVote(vote: .downvote)
                }) {
                    Text("Downvote")
                }
                .disabled(uiState.selectedPost != nil)
                .keyboardShortcut(.downArrow, modifiers: .shift)
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
            SettingsView()
        }
    }
}
