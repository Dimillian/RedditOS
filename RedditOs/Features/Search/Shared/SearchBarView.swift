//
//  SearchBarView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @State private var isFocused = false
    
    let onEditingChange: (Bool) -> Void
    let onCommit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search anything", text: $searchText) { editing in
                isFocused = editing
                onEditingChange(editing)
            } onCommit: {
                onCommit()
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color.accentColor : Color.clear)
                            .background(Color.black.opacity(0.2).cornerRadius(8)))
            .textFieldStyle(PlainTextFieldStyle())
            .animation(.easeInOut)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
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
