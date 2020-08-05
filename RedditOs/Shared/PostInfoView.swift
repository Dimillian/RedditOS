//
//  ListingInfoView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct PostInfoView: View {
    @EnvironmentObject private var uiState: UIState
    
    let post: SubredditPost
    @State private var showUserPopover = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("r/\(post.subreddit)")
                .fontWeight(.bold)
                .font(.subheadline)
            Button(action: {
                showUserPopover = true
            }, label: {
                HStack(spacing: 4) {
                    Image(systemName: "person")
                    Text("u/\(post.author)")
                }
            })
            .buttonStyle(BorderlessButtonStyle())
            .popover(isPresented: $showUserPopover, content: {
                UserPopoverView(username: post.author)
            })
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(post.createdUtc, style: .offset)
                }
                HStack(spacing: 4) {
                    Image(systemName: "bubble.middle.bottom")
                        .imageScale(.small)
                    Text("\(post.numComments)")
                }
                if !post.allAwardings.isEmpty {
                    PostAwardsView(awards: post.allAwardings)
                }
            }
            .font(.callout)
            .foregroundColor(.gray)
        }
    }
}

struct ListingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PostInfoView(post: static_listing)
    }
}
