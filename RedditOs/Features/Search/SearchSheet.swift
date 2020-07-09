//
//  SearchSubredditsPopover.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI

struct SearchSubredditsPopover: View {
    @State private var search = ""
    var body: some View {
        List {
            TextField("Search", text: $search)
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
