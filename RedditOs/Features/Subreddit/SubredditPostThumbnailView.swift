//
//  SubredditPostThubnailView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 21/07/2020.
//

import SwiftUI
import Backend
import KingfisherSwiftUI

struct SubredditPostThumbnailView: View {
    @ObservedObject var viewModel: PostViewModel
    
    private var post: SubredditPost {
        viewModel.post
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let url = post.thumbnailURL ?? post.secureMedia?.oembed?.thumbnailUrlAsURL {
                KFImage(url)
                    .frame(width: 80, height: 60)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } else {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 80, height: 60)
                        .foregroundColor(.redditGray)
                    if post.url != nil {
                        if post.selftext == nil || post.selftext?.isEmpty == true {
                            Image(systemName: "link")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            if post.saved {
                Image(systemName: "bookmark.fill")
                    .imageScale(.medium)
                    .foregroundColor(.accentColor)
                    .padding(.leading, 6)
                    .padding(.top, -2)
                    .transition(.move(edge: .top))
                    .animation(.interactiveSpring())
            }
        }
    }
}

struct SubredditPostThubnailView_Previews: PreviewProvider {
    static var previews: some View {
        SubredditPostThumbnailView(viewModel: PostViewModel(post: static_listing))
    }
}
