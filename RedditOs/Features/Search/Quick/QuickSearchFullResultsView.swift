//
//  SearchMainContentView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 15/05/2021.
//

import SwiftUI

struct QuickSearchFullResultsView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var searchState: QuickSearchState
    
    enum ResultsMode {
        case autocomplete, posts
    }
    
    @State private var resultsDisplayMode = ResultsMode.autocomplete
    
    var body: some View {
        VStack(alignment: .leading) {
            if let route = uiState.searchRoute {
                route.makeView()
                    .toolbar {
                        ToolbarItemGroup(placement: .navigation) {
                            Button {
                                uiState.searchRoute = nil
                                resultsDisplayMode = .autocomplete
                            } label: {
                                Text("Back")
                            }
                        }
                    }
            } else {
                QuickSearchBar(showSuggestionPopover: false,
                          onCommit: {
                    resultsDisplayMode = .posts
                }, onCancel: {
                    resultsDisplayMode = .autocomplete
                })
                .padding()
                resultsView
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                Spacer()
            }
        }
        .navigationTitle("Search")
        .onAppear {
            searchState.fetchTrending()
        }
        .frame(minWidth: 300)
    }
    
    @ViewBuilder
    private var resultsView: some View {
        switch resultsDisplayMode {
        case .autocomplete:
            List {
                if searchState.searchText.isEmpty {
                    if let trending = searchState.trending {
                        Section(header: Label("Trending", systemImage: "chart.bar.fill")) {
                            ForEach(trending.subredditNames, id: \.self) { subreddit in
                                Text(subreddit)
                                    .padding(.vertical, 4)
                                    .onTapGesture {
                                        uiState.searchRoute = .subreddit(subreddit: subreddit)
                                    }
                            }
                        }
                    }
                } else {
                    QuickSearchResultsView()
                }
            }
        case .posts:
            QuickSearchPostsResultView()
        }
    }
}

struct QuickSearchFullResultsView_Previews: PreviewProvider {
    static var previews: some View {
        QuickSearchFullResultsView().environmentObject(UIState())
    }
}
