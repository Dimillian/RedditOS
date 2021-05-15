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
                if !searchState.searchText.isEmpty {
                    List {
                        GlobalSearchPopoverView()
                    }.listStyle(PlainListStyle())
                }
                Spacer()
            }
        }.navigationTitle("Search")
    }
}

struct SearchMainContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMainContentView().environmentObject(UIState.shared)
    }
}
