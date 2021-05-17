//
//  GeneralTabView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI

struct GeneralTabView: View {
    @AppStorage(SettingsKey.subreddit_display_mode) private var displayMode: SubredditPostRow.DisplayMode = .large
    @AppStorage(SettingsKey.subreddit_defaut_sort_order) private var sortOrder: SubredditViewModel.SortOrder = .hot
    
    var body: some View {
        Form {
            Section(header: Text("Default Subreddit settings")) {
                
                Picker("Display layout style", selection: $displayMode) {
                    ForEach(SubredditPostRow.DisplayMode.allCases, id: \.self) { mode in
                        Label(mode.rawValue, systemImage: mode.symbol()).tag(mode)
                    }
                }
                
                Picker(selection: $sortOrder, label: Text("Sort order")) {
                    ForEach(SubredditViewModel.SortOrder.allCases, id: \.self) { sort in
                        Text(sort.rawValue.capitalized).tag(sort)
                    }
                }
                
            }
        }
        .padding()
        .frame(width: 400, height: 150)
    }
}

struct GeneralTabView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralTabView()
    }
}

