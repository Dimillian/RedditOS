//
//  ToolbarSearchBar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 28/07/2020.
//

import SwiftUI

struct ToolbarSearchBar: View {
    @EnvironmentObject private var uiState: UIState
    @State private var isFocused = false
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        TextField("Search anything", text: $searchViewModel.searchText) { editing in
            isFocused = editing
        } onCommit: {
            uiState.presentedNavigationRoute = .subreddit(subreddit: searchViewModel.searchText, isSheet: false)
        }
        .keyboardShortcut("f", modifiers: .command)
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.accentColor : Color.clear)
                        .background(Color.black.opacity(0.2).cornerRadius(8)))
        .textFieldStyle(PlainTextFieldStyle())
        .frame(width: 300)
        .popover(isPresented: $isFocused) {
            GlobalSearchPopoverView(viewModel: searchViewModel)
        }
    }
}

struct ToolbarSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarSearchBar()
    }
}
