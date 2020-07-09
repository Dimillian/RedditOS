//
//  SubredditView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct SubredditView: View {
    let posts = Array(repeating: 0, count: 20)
    
    @StateObject private var viewModel: SubredditViewModel
    @State private var isSearchSheetOpen = false
    
    init(name: String) {
        _viewModel = StateObject(wrappedValue: SubredditViewModel(name: name))
    }
    
    @State private var search = ""
    
    var body: some View {
        NavigationView {
            List {
                if let listings = viewModel.listings {
                    ForEach(listings) { listing in
                        SubredditPostRow(listing: listing)
                    }
                    HStack {
                        Spacer()
                        ProgressView("Loading next page")
                        Spacer()
                    }.onAppear(perform: viewModel.fetchListings)
              
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .listStyle(InsetListStyle())
            .frame(width: 400)
            
            Text("Select a post")
                .frame(minWidth: 250,
                       maxWidth: .infinity,
                       maxHeight: .infinity)
        }
        .navigationTitle("r/\(viewModel.name)")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    isSearchSheetOpen = true
                }) {
                    Image(systemName: "magnifyingglass")
                }.popover(isPresented: $isSearchSheetOpen) {
                    SearchSubredditsPopover()
                }
            }
        }
        .onAppear(perform: viewModel.fetchListings)
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        SubredditView(name: "Best")
    }
}
