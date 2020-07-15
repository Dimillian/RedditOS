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
    
    @EnvironmentObject private var userData: PersistedContent
    @StateObject private var viewModel: SubredditViewModel
    @AppStorage("postDisplayMode") private var displayMode = SubredditPostRow.DisplayMode.large
    @State private var isSearchSheetOpen = false
    
    init(name: String) {
        _viewModel = StateObject(wrappedValue: SubredditViewModel(name: name))
    }
    
    var isDefaultChannel: Bool {
        SidebarViewModel.MainSubreddits.allCases.map{ $0.rawValue }.contains(viewModel.name)
    }
    
    var body: some View {
        NavigationView {
            List {
                if let listings = viewModel.listings {
                    ForEach(listings) { listing in
                        SubredditPostRow(listing: listing, displayMode: displayMode)
                    }
                    LoadingRow(text: "Loading next page")
                        .onAppear(perform: viewModel.fetchListings)
              
                } else {
                    LoadingRow(text: nil)
                }
            }
            .listStyle(InsetListStyle())
            .frame(width: 430)

        }
        .navigationTitle(isDefaultChannel ? "\(viewModel.name.capitalized)" : "r/\(viewModel.name)")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Picker(selection: $displayMode,
                       label: Text("Display"),
                       content: {
                        ForEach(SubredditPostRow.DisplayMode.allCases, id: \.self) { mode in
                            HStack {
                                Text(mode.rawValue.capitalized)
                                Image(systemName: mode.iconName())
                                    .tag(mode)
                            }
                        }
                }).pickerStyle(DefaultPickerStyle())
            }
            
            ToolbarItem(placement: .primaryAction) {
                if !isDefaultChannel {
                    Picker(selection: $viewModel.sortOrder,
                           label: Text("Sorting"),
                           content: {
                            ForEach(SubredditViewModel.SortOrder.allCases, id: \.self) { sort in
                                Text(sort.rawValue.capitalized).tag(sort)
                            }
                           })
                } else {
                    EmptyView()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isSearchSheetOpen = true
                }) {
                    Image(systemName: "magnifyingglass")
                }.popover(isPresented: $isSearchSheetOpen) {
                    SearchSubredditsPopover().environmentObject(userData)
                }
            }
        }
        .onAppear(perform: viewModel.fetchListings)
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostsListView(name: "Best")
    }
}
