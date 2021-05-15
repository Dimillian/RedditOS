//
//  SearchMainContentView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 15/05/2021.
//

import SwiftUI

struct SearchMainContentView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var searchState: SearchState
    
    var body: some View {
        VStack(alignment: .leading) {
            if let route = uiState.searchRoute {
                HStack {
                    Button {
                        uiState.searchRoute = nil
                    } label: {
                        Text("Back")
                    }
                    .padding(8)
                    Spacer()
                }
                .background(Color.redditGray)
                .frame(height: 50)
                route.makeView()
            } else {
                ToolbarSearchBar(isPopoverEnabled: false)
                    .padding()
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
                        GlobalSearchPopoverView()
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                Spacer()
            }
        }.navigationTitle("Search")
        .onAppear {
            searchState.fetchTrending()
        }
    }
}

struct SearchMainContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMainContentView().environmentObject(UIState.shared)
    }
}
