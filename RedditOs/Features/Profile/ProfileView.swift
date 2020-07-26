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
    @EnvironmentObject private var oauthClient: OauthClient
    @EnvironmentObject private var currentUser: CurrentUserStore
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    if let user = currentUser.user {
                        UserView(user: user)
                    } else {
                        HStack {
                            Spacer()
                            authView
                            Spacer()
                        }
                    }
                }.padding(.top, 16)
            }
            .listStyle(PlainListStyle())
            
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
    var authView: some View {
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
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
