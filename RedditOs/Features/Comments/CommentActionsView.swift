//
//  CommentActionsView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 12/08/2020.
//

import SwiftUI
import Backend

struct CommentActionsView: View {
    @ObservedObject var viewModel: CommentViewModel
    @State private var showPicker = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                
            }, label: {
                Label("Reply", systemImage: "bubble.right")
            }).buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                showPicker.toggle()
            }, label: {
                Label("Share", systemImage: "square.and.arrow.up")
            })
            .buttonStyle(BorderlessButtonStyle())
            .background(SharingsPicker(isPresented: $showPicker,
                                       sharingItems: [viewModel.comment.permalinkURL ?? ""]))
            
            Button(action: {
                viewModel.toggleSave()
            }, label: {
                Label("Save",
                      systemImage: viewModel.comment.saved == true ? "bookmark.fill" : "bookmark")
            }).buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                
            }, label: {
                Label("Report", systemImage: "flag")
            }).buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct CommentActionsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentActionsView(viewModel: CommentViewModel(comment: static_comment))
    }
}
