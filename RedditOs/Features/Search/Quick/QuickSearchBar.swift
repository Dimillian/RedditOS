//
//  ToolbarSearchBar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 28/07/2020.
//

import SwiftUI

struct QuickSearchBar: View {
    @EnvironmentObject private var searchState: QuickSearchState
    @State private var isFocused = false
    @State private var isPopoverPresented = false
    
    let showSuggestionPopover: Bool
    let onCommit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        SearchBarView(placeholder: NSLocalizedString("Search anything",
                                                     comment: "placeholder for search"),
                      searchText: $searchState.searchText) { editing in
            if showSuggestionPopover {
                isPopoverPresented = editing
            }
        } onCommit: {
            onCommit()
        } onCancel: {
            onCancel()
        }
        .popover(isPresented: $isPopoverPresented) {
            ScrollView {
                VStack(alignment: .leading) {
                    QuickSearchResultsView()
                }.padding()
            }.frame(width: 300, height: 500)
        }
    }
}

struct QuickSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        QuickSearchBar(showSuggestionPopover: true,
                  onCommit: { },
                  onCancel: { }).environmentObject(QuickSearchState())
    }
}
