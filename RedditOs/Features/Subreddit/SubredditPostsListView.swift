//
//  SubredditPostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct SubredditPostsListView: View {
    let posts = Array(repeating: 0, count: 20)
    
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    @EnvironmentObject private var localData: LocalDataStore
    @StateObject private var viewModel: SubredditViewModel
    @AppStorage(SettingsKey.subreddit_display_mode) private var displayMode = SubredditPostRow.DisplayMode.large
    
    init(name: String) {
        _viewModel = StateObject(wrappedValue: SubredditViewModel(name: name))
    }
    
    var isDefaultChannel: Bool {
        UIState.DefaultChannels.allCases.map{ $0.rawValue }.contains(viewModel.name)
    }
    
    var subtitle: String {
        if isDefaultChannel {
            return ""
        }
        if let subscribers = viewModel.subreddit?.subscribers, let connected = viewModel.subreddit?.accountsActive {
            return "\(subscribers.toRoundedSuffixAsString()) subscribers - \(connected.toRoundedSuffixAsString()) active"
        }
        return ""
    }
    
    var body: some View {
        NavigationView {
            PostsListView(posts: viewModel.listings,
                          displayMode: .constant(displayMode)) {
                viewModel.fetchListings()
            }.onAppear(perform: viewModel.fetchListings)
            PostNoSelectionPlaceholder()
        }
        .navigationTitle(viewModel.name.capitalized)
        .navigationSubtitle(subtitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Picker("",
                       selection: $displayMode,
                       content: {
                        ForEach(SubredditPostRow.DisplayMode.allCases, id: \.self) { mode in
                            Image(systemName: mode.iconName())
                                .tag(mode)
                        }
                       }).pickerStyle(InlinePickerStyle())
            }
            
            ToolbarItem(placement: .primaryAction) {
                if isDefaultChannel {
                    Text("")
                } else {
                    Picker(selection: $viewModel.sortOrder,
                           label: Text("Sorting"),
                           content: {
                            ForEach(SubredditViewModel.SortOrder.allCases, id: \.self) { sort in
                                Text(sort.rawValue.capitalized).tag(sort)
                            }
                        })
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    
                }) {
                    Image(systemName: "info")
                }
                .keyboardShortcut("i", modifiers: .command)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .keyboardShortcut("s", modifiers: .command)
            }
            
            ToolbarItem(placement: .primaryAction) {
                ToolbarSearchBar()
            }
        }
        .onAppear(perform: viewModel.fetchListings)
        .onAppear {
            if !isDefaultChannel {
                viewModel.fetchAbout()
            }
        }
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostsListView(name: "Best")
    }
}
