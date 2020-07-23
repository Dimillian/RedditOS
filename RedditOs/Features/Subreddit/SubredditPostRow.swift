//
//  SubredditPostRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct SubredditPostRow: View {
    enum DisplayMode: String, CaseIterable {
        case compact, large
        
        func iconName() -> String {
            switch self {
            case .compact: return "list.bullet"
            case .large: return "list.bullet.below.rectangle"
            }
        }
    }
    
    @StateObject var viewModel: PostViewModel
    let displayMode: DisplayMode
    @Binding var selectedPost: SubredditPost?
    
    @Environment(\.openURL) private var openURL
    
    init(post: SubredditPost, displayMode: DisplayMode, selectedPost: Binding<SubredditPost?>) {
        _viewModel = StateObject(wrappedValue: PostViewModel(post: post))
        _selectedPost = selectedPost
        self.displayMode = displayMode
    }
        
    var body: some View {
        NavigationLink(
            destination: PostDetail(viewModel: viewModel),
            tag: viewModel.post,
            selection: $selectedPost) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 8) {
                        PostVoteView(viewModel: viewModel)
                        if displayMode == .large {
                            SubredditPostThumbnailView(post:viewModel.post)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.post.title)
                                .fontWeight(.bold)
                                .font(.headline)
                                .lineLimit(displayMode == .compact ? 2 : nil)
                            HStack {
                                FlairView(post: viewModel.post)
                                if (viewModel.post.selftext == nil || viewModel.post.selftext?.isEmpty == true),
                                   displayMode == .large,
                                   let urlString = viewModel.post.url,
                                   let url = URL(string: urlString) {
                                    Link(destination: url) {
                                        Text(url.host ?? url.absoluteString)
                                    }
                                }
                            }
                            PostInfoView(post: viewModel.post)
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(width: 470)
        .padding(.vertical, 8)
        .contextMenu {
            Button {
                viewModel.vote(vote: .upvote)
            } label: { Text("Upvote") }
            Button {
                viewModel.vote(vote: .downvote)
            } label: { Text("Downvote") }
            Button {
                if let url = viewModel.post.redditURL {
                    openURL(url)
                }
            } label: { Text("Open in browser") }
            Button {
                if let url = viewModel.post.redditURL {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(url.absoluteString, forType: .string)
                }
                
            } label: { Text("Copy URL") }
        }
    }
}

struct SubredditPostRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SubredditPostRow(post: static_listing, displayMode: .large, selectedPost: .constant(nil))
            SubredditPostRow(post: static_listing, displayMode: .large, selectedPost: .constant(nil))
            SubredditPostRow(post: static_listing, displayMode: .large, selectedPost: .constant(nil))
            
            Divider()
            
            SubredditPostRow(post: static_listing, displayMode: .compact, selectedPost: .constant(nil))
            SubredditPostRow(post: static_listing, displayMode: .compact, selectedPost: .constant(nil))
            SubredditPostRow(post: static_listing, displayMode: .compact, selectedPost: .constant(nil))
        }
    }
}
