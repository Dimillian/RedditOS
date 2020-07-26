//
//  UserSheetOverviewView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Combine
import Backend

struct UserSheetOverviewView: View {
    @ObservedObject var viewModel: UserViewModel
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    var body: some View {
        List {
            if let user = viewModel.user {
                UserHeaderView(user: user)
                    .padding(.vertical, 16)
            }
            if let overview = viewModel.overview {
                let posts = overview.compactMap{ $0.post }
                ForEach(posts) { post in
                    SubredditPostRow(post: post, displayMode: .constant(.large))
                }
                LoadingRow(text: "Loading next page")
                    .onAppear {
                        viewModel.fetchOverview()
                }
            } else {
                ForEach(loadingPlaceholders) { post in
                    SubredditPostRow(post: post, displayMode: .constant(.large))
                        .redacted(reason: .placeholder)
                }
            }
        }
        .listStyle(InsetListStyle())
        .frame(width: 500)
    }
}
