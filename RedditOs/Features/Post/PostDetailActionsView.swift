//
//  PostDetailActions.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend

struct PostDetailActionsView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "bubble.middle.bottom.fill")
                    .imageScale(.medium)
                Text("\(viewModel.post.numComments) comments")
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.medium)
                Text("Share")
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 6) {
                Button(action: {
                    viewModel.toggleSave()
                }) {
                    Image(systemName: viewModel.post.saved ? "bookmark.fill": "bookmark")
                        .imageScale(.medium)
                        .foregroundColor(viewModel.post.saved ? .accentColor : .white)
                    Text("Save")
                        .foregroundColor(.white)
                }.buttonStyle(BorderlessButtonStyle())
            }
            
            HStack(spacing: 6) {
                Image(systemName: "flag")
                    .imageScale(.medium)
                Text("Report")
                    .foregroundColor(.white)
            }
            
        }
    }
}

struct PostDetailActions_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailActionsView(viewModel: PostViewModel(post: static_listing))
    }
}
