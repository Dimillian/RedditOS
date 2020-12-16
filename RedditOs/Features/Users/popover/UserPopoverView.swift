//
//  UserPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI

struct UserPopoverView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject private var uiState: UIState
    @StateObject private var viewModel: UserViewModel
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: UserViewModel(username: username))
    }
    var body: some View {
        Group {
            if let user = viewModel.user {
                VStack(alignment: .center) {
                    Text(user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                    Spacer()
                    UserHeaderView(user: user)
                    Spacer()
                    Button(action: {
                        if let user = viewModel.user {
                            presentation.wrappedValue.dismiss()
                            uiState.presentedSheetRoute = .user(user: user, isSheet: true)
                        }
                    }) {
                        Text("View full profile")
                    }
                    .padding(.bottom, 16)
                }
            } else {
                LoadingRow(text: "Loading user")
            }
        }.frame(width: 420, height: 200)
    }
}

struct UserPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        UserPopoverView(username: "").environmentObject(UIState.shared)
    }
}
