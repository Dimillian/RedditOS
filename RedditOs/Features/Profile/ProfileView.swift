//
//  ProfileView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 11/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct ProfileView: View {
    enum OverviewFilter: String, CaseIterable {
        case posts, comments
    }
    
    @EnvironmentObject private var oauthClient: OauthClient
    @EnvironmentObject private var currentUser: CurrentUserStore
    @Environment(\.openURL) private var openURL
    @State private var overviewFilter = OverviewFilter.posts
    
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    var body: some View {
        NavigationView {
            List {
                headerView.padding(.vertical, 16)
                if currentUser.user != nil {
                    userOverview
                }
            }
            
            PostNoSelectionPlaceholder()
        }
        .navigationTitle("Profile")
        .navigationSubtitle(currentUser.user?.name ?? "Login")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    oauthClient.logout()
                } label: {
                    Text("Logout")
                }

            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        if let user = currentUser.user {
            UserHeaderVIew(user: user)
                .onAppear {
                    currentUser.fetchOverview(after: nil)
            }
        } else {
            authView
        }
    }
    
    @ViewBuilder
    private var userOverview: some View {
        if let overview = currentUser.overview {
            Picker("", selection: $overviewFilter) {
                ForEach(OverviewFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue.capitalized)
                        .tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 12)
            
            if overviewFilter == .posts {
                let posts = overview.compactMap{ $0.post }
                ForEach(posts) { post in
                    SubredditPostRow(post: post, displayMode: .constant(.large))
                }
            } else if overviewFilter == .comments {
                let comments = overview.compactMap{ $0.comment }
                ForEach(comments) { comment in
                    CommentRow(comment: comment)
                }
            }
            // This is crashing SwiftUI for now.
            /*
            ForEach(overview) { content in
                switch content {
                case let .post(post):
                    SubredditPostRow(post: post, displayMode: .constant(.large))
                case let .comment(comment):
                    CommentRow(comment: comment)
                default:
                    Text("Unsupported view")
                }
            }
             */
        } else {
            ForEach(loadingPlaceholders) { post in
                SubredditPostRow(post: post, displayMode: .constant(.large))
                    .redacted(reason: .placeholder)
            }
        }
    }
        
    @ViewBuilder
    private var authView: some View {
        HStack {
            Spacer()
            switch oauthClient.authState {
            case .signedOut:
                Button {
                    if let url = oauthClient.startOauthFlow() {
                        openURL(url)
                    }
                } label: {
                    Text("Sign in")
                }
            case .signinInProgress:
                ProgressView("Auth in progress")
            case .authenthicated:
                Text("Signed in")
            case .unknown:
                Text("Error")
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
