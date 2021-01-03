//
//  SubredditPostsListView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import UI
import SDWebImageSwiftUI

struct SubredditPostsListView: View {
    let posts = Array(repeating: 0, count: 20)
    
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var localData: LocalDataStore
    
    @StateObject private var viewModel: SubredditViewModel
    @AppStorage(SettingsKey.subreddit_display_mode) private var displayMode = SubredditPostRow.DisplayMode.large
    
    @State private var subredditAboutPopoverShown = false
    @State private var sharePickerShown = false
    
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
            return "\(subscribers.toRoundedSuffixAsString()) members - \(connected.toRoundedSuffixAsString()) online"
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
            ToolbarItem(placement: .navigation) {
                Group {
                    if isDefaultChannel {
                        EmptyView()
                    } else if let icon = viewModel.subreddit?.iconImg, let url = URL(string: icon) {
                        WebImage(url: url)
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
                         content: { SubredditAboutPopoverView(subreddit: viewModel.subreddit) })
            }
            
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
                    sharePickerShown.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .background(SharingsPicker(isPresented: $sharePickerShown,
                                           sharingItems: [uiState.selectedPost?.post.redditURL ??
                                                            viewModel.subreddit?.redditURL ??
                                                            ""]))
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
            uiState.selectedSubreddit = viewModel
        }
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostsListView(name: "Best")
    }
}
