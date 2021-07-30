//
//  SearchBarView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI

struct SearchBarView: View {
    let placeholder: String
    @Binding var searchText: String
    let onEditingChange: (Bool) -> Void
    let onCommit: () -> Void
    let onCancel: () -> Void
    
    @State private var isFocused = false
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $searchText) { editing in
                isFocused = editing
                onEditingChange(editing)
            } onCommit: {
                onCommit()
            }
            .keyboardShortcut("f", modifiers: .command)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color.accentColor : Color.clear)
                            .background(Color.black.opacity(0.2).cornerRadius(8)))
            .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    onCancel()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title2)
                }
                .buttonStyle(BorderlessButtonStyle())
                .transition(.move(edge: .trailing))
            }
        }
    }
}
