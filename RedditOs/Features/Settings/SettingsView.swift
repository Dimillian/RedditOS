//
//  SettingsView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(SettingsKey.subreddit_display_mode) private var displayMode = SubredditPostRow.DisplayMode.large
    @AppStorage(SettingsKey.subreddit_defaut_sort_order) private var sortOrder = SubredditViewModel.SortOrder.hot
    
    var body: some View {
        TabView {
            generalView
                .tabItem {
                    Image(systemName: "gearshape").imageScale(.large)
                    Text("General")
            }
            
            Text("Apperance")
                .tabItem {
                    Image(systemName: "textformat.alt").imageScale(.large)
                    Text("Apperance")
            }
            
            Text("Filters")
                .tabItem {
                    Image(systemName: "stop.circle").imageScale(.large)
                    Text("Filters")
            }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass").imageScale(.large)
                    Text("Search")
            }
            
            Text("Accounts")
                .tabItem {
                Image(systemName: "person").imageScale(.large)
                Text("Accounts")
            }
        }.frame(width: 1000, height: 500)
    }
    
    private var generalView: some View {
        Form {
            Section(header: Text("Subreddit settings")) {
                Picker("Display mode",
                       selection: $displayMode,
                       content: {
                        ForEach(SubredditPostRow.DisplayMode.allCases, id: \.self) { mode in
                            Label(mode.rawValue, systemImage: mode.iconName()).tag(mode)
                        }
                       })
                
                Picker(selection: $sortOrder,
                       label: Text("Default sort"),
                       content: {
                        ForEach(SubredditViewModel.SortOrder.allCases, id: \.self) { sort in
                            Text(sort.rawValue.capitalized).tag(sort)
                        }
                       })
            }
        }.frame(width: 500)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
