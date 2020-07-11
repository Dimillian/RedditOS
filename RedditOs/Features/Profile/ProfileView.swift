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
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            Spacer()
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
            Spacer()
        }.frame(minWidth: 400, minHeight: 500)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
