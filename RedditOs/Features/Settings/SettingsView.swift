//
//  SettingsView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        TabView {
            GeneralTabView()
                .tabItem {
                    Image(systemName: "gearshape").imageScale(.large)
                    Text("General")
                }
            
            SidebarTabView()
                .tabItem {
                    Image(systemName: "sidebar.left").imageScale(.large)
                    Text("Sidebar")
                }
            
            Text("Filters")
                .frame(width: 400, height: 150)
                .tabItem {
                    Image(systemName: "stop.circle").imageScale(.large)
                    Text("Filters")
                }
            
            Text("Search")
                .frame(width: 400, height: 150)
                .tabItem {
                    Image(systemName: "magnifyingglass").imageScale(.large)
                    Text("Search")
                }
            
            Text("Accounts")
                .frame(width: 400, height: 150)
                .tabItem {
                    Image(systemName: "person").imageScale(.large)
                    Text("Accounts")
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

