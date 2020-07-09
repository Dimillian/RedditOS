//
//  SearchSubredditsPopover.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI

struct SearchSubredditsPopover: View {
    @StateObject private var viewModel = SearchSubredditsViewModel()
    
    var body: some View {
        List {
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .navigationTitle("Search")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {}) {
                    Image(systemName: "xmark.circle")
                }
            }
        }
    }
}

struct SearchSheet_Previews: PreviewProvider {
    static var previews: some View {
        SearchSubredditsPopover()
    }
}
