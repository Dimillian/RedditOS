//
//  ProfileView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 11/07/2020.
//

import SwiftUI
import Backend

struct ProfileView: View {
    @EnvironmentObject private var oauthClient: OauthClient
    @EnvironmentObject private var currentUser: CurrentUserStore
    @Environment(\.openURL) private var openURL
    
    private let loadingPlaceholders = Array(repeating: static_listing, count: 10)
    
    var body: some View {
        NavigationView {
            List {
                headerView.padding(.vertical, 16)
                if currentUser.user != nil {
                    userOverview
                }
            }
            .listStyle(InsetListStyle())
            .frame(width: 500)
            
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
            UserHeaderView(user: user)
                .onAppear {
                    currentUser.fetchOverview()
            }
        } else {
            authView
        }
    }
    
    @ViewBuilder
    private var userOverview: some View {
        if let overview = currentUser.overview {
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
            LoadingRow(text: "Loading next page")
                .onAppear {
                    currentUser.fetchOverview()
                }
        } else {
            ForEach(loadingPlaceholders) { post in
                SubredditPostRow(post: post,
                                 displayMode: .constant(.large))
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
