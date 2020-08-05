//
//  ToolbarSearchBar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 28/07/2020.
//

import SwiftUI

struct ToolbarSearchBar: View {
    @State private var isFocused = false
    @State private var searchText = ""
    
    var body: some View {
        TextField("Search anything", text: $searchText) { editing in
            isFocused = editing
        } onCommit: {
            
        }
        .keyboardShortcut("f", modifiers: .command)
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.accentColor : Color.clear)
                        .background(Color.black.opacity(0.2).cornerRadius(8)))
        .textFieldStyle(PlainTextFieldStyle())
        .frame(width: 500)
        .popover(isPresented: $isFocused) {
            Text("Search results coming soon")
            .frame(width: 500, height: 500)
        }
    }
}

struct ToolbarSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarSearchBar()
    }
}
