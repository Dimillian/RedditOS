//
//  RedditOsApp.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI

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
            }.frame(minHeight: 400)
        }
        
        Settings {
            Text("Hello world")
        }
    }
}
