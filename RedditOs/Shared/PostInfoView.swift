//
//  ListingInfoView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI
import Backend

struct PostInfoView: View {
    enum Display {
        case vertical, horizontal
    }
    
    @EnvironmentObject private var uiState: UIState
    
    let post: SubredditPost
    let display: Display
    
    @State private var showUserPopover = false
    
    var body: some View {
        switch display {
        case .vertical:
            VStack(alignment: .leading, spacing: 6) {
                content
            }.font(.callout)
        case .horizontal:
            HStack(spacing: 12) {
                content
            }.font(.callout)
        }
    }
    
    @ViewBuilder
    var content: some View {
        HStack(spacing: 6) {
            Button(action: {
                uiState.presentedSheetRoute = .subreddit(subreddit: post.subreddit, isSheet: true)
            }, label: {
                Text("r/\(post.subreddit)")
                    .fontWeight(.bold)
            })
            .buttonStyle(BorderlessButtonStyle())
            
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
            if let richText = post.authorFlairRichtext, !richText.isEmpty {
                FlairView(richText: richText,
                          textColorHex: post.authorFlairTextColor,
                          backgroundColorHex: post.authorFlairBackgroundColor,
                          display: .small)
            }
        }
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
                AwardsView(awards: post.allAwardings)
            }
        }
        .foregroundColor(.gray)
    }
}

struct ListingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PostInfoView(post: static_listing, display: .horizontal)
            PostInfoView(post: static_listing, display: .vertical)
        }
    }
}
