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
    @State private var showPicker = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                
            }, label: {
                Label("\(viewModel.post.numComments) comments", systemImage: "bubble.middle.bottom.fill")
                    .foregroundColor(.white)
            }).buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                showPicker.toggle()
            }, label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .foregroundColor(.white)
            })
            .buttonStyle(BorderlessButtonStyle())
            .background(SharingsPicker(isPresented: $showPicker,
                                       sharingItems: [viewModel.post.redditURL ?? ""]))
            

            Button(action: {
                viewModel.toggleSave()
            }, label: {
                Label(viewModel.post.saved ? "Saved" : "Save",
                      systemImage: viewModel.post.saved ? "bookmark.fill": "bookmark")
                    .foregroundColor(viewModel.post.saved ? .accentColor : .white)
            }).buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                
            }, label: {
                Label("Report", systemImage: "flag")
                    .foregroundColor(.white)
            }).buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct PostDetailActions_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailActionsView(viewModel: PostViewModel(post: static_listing))
    }
}
