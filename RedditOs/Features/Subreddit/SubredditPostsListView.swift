//
//  SubredditPostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import UI
import Kingfisher

struct SubredditPostsListView: View, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.displayMode == rhs.displayMode
    }
        
    private let name: String
    private let isSheet: Bool
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var localData: LocalDataStore
    
    @StateObject private var viewModel: SubredditViewModel
    @AppStorage(SettingsKey.subreddit_display_mode) private var displayMode = SubredditPostRow.DisplayMode.large
    
    @State private var subredditAboutPopoverShown = false
    
    init(name: String, isSheet: Bool = false) {
        self.name = name
        self.isSheet = isSheet
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
            return "\(subscribers.toRoundedSuffixAsString()) members - \(connected.toRoundedSuffixAsString()) online"
        }
        return ""
    }
    
    var body: some View {
        PostsListView(posts: viewModel.listings,
                      displayMode: .constant(displayMode)) {
            viewModel.fetchListings()
        }
        .equatable()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Group {
                    if isDefaultChannel {
                        EmptyView()
                    } else if let icon = viewModel.subreddit?.iconImg, let url = URL(string: icon) {
                        KFImage(url)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .onTapGesture {
                    subredditAboutPopoverShown = true
                }
                .popover(isPresented: $subredditAboutPopoverShown,
                         content: { SubredditAboutPopoverView(viewModel: viewModel) })
            }
            
            ToolbarItem {
                Picker("Display layout", selection: $displayMode) {
                    ForEach(SubredditPostRow.DisplayMode.allCases, id: \.self) { item in
                        Image(systemName: item.symbol())
                            .tag(item)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .help("Select display layout style")
            }
            
            ToolbarItem {
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
        }
        .navigationTitle(viewModel.name.capitalized)
        .navigationSubtitle(subtitle)
        .frame(minHeight: 500)
        .onAppear {
            if !isDefaultChannel {
                viewModel.fetchAbout()
            }
            uiState.selectedSubreddit = viewModel
        }
        .onAppear(perform: viewModel.fetchListings)
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostsListView(name: "Best")
    }
}


