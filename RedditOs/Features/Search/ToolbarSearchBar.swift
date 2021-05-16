//
//  ToolbarSearchBar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 28/07/2020.
//

import SwiftUI

struct ToolbarSearchBar: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var searchState: SearchState
    @State private var isFocused = false
    @State private var isPopoverPresented = false
    
    let isPopoverEnabled: Bool
    let onCommit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search anything", text: $searchState.searchText) { editing in
                isFocused = editing
                if isPopoverEnabled {
                    isPopoverPresented = editing
                }
            } onCommit: {
                onCommit()
            }
            .keyboardShortcut("f", modifiers: .command)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color.accentColor : Color.clear)
                            .background(Color.black.opacity(0.2).cornerRadius(8)))
            .textFieldStyle(PlainTextFieldStyle())
            .animation(.easeInOut)
            .popover(isPresented: $isPopoverPresented) {
                ScrollView {
                    VStack(alignment: .leading) {
                        GlobalSearchPopoverView()
                    }.padding()
                }.frame(width: 300, height: 500)
            }
            if !searchState.searchText.isEmpty {
                Button {
                    searchState.searchText = ""
                    onCancel()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title2)
                }
                .buttonStyle(BorderlessButtonStyle())
                .animation(.easeInOut)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct ToolbarSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarSearchBar(isPopoverEnabled: true, onCommit: { }, onCancel: { }).environmentObject(SearchState())
    }
}
