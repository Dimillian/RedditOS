//
//  UserPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI

struct UserPopoverView: View {
    @StateObject private var viewModel: UserPopoverViewModel
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: UserPopoverViewModel(username: username))
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
                }
            } else {
                LoadingRow(text: "Loading user")
            }
        }.frame(width: 420, height: 200)
    }
}

struct UserPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        UserPopoverView(username: "")
    }
}
