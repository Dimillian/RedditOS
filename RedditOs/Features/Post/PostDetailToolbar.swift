//
//  PostDetailToolbar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 21/09/2020.
//

import SwiftUI

struct PostDetailToolbar: ToolbarContent {
    let shareURL: URL?
        
    var body: some ToolbarContent {
        ToolbarItemGroup {
            SharingView(url: shareURL)
            Spacer()
            SearchView()
        }
    }
}

struct SearchView: View {
    @State private var isExpanded = false
    @EnvironmentObject private var uiState: UIState
    
    var body: some View {
        if uiState.displayToolbarSearchBar {
            if !isExpanded {
                Button {
                    isExpanded.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            } else {
                QuickSearchBar(showSuggestionPopover: true,
                               onCommit: {},
                               onCancel: {
                                self.isExpanded = false
                               })
                    .frame(width: 300)
                    .transition(.slide)
                    .animation(.easeInOut)
            }
        }
    }
}

struct SharingView: View {
    let url: URL?
    @State private var sharePickerShown = false
    
    var body: some View {
        Button(action: {
            sharePickerShown.toggle()
        }) {
            Image(systemName: "square.and.arrow.up")
        }.background(SharingsPicker(isPresented: $sharePickerShown,
                                    sharingItems: [url ?? ""]))
        
    }
}
