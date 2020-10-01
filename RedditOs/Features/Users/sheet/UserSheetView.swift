//
//  UserSheetView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI
import Backend

struct UserSheetView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel: UserViewModel
    @State private var sidebarSelection: Set<Int> = [1]
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: UserViewModel(username: username))
    }
    
    var body: some View {
        NavigationView {
            List(selection: $sidebarSelection) {
                Section(header: Text(viewModel.username)) {
                    Label("Overview", systemImage: "square.and.pencil").tag(1)
                    Label("Posts", systemImage: "square.and.pencil").tag(2)
                    Label("Comments", systemImage: "text.bubble").tag(3)
                    Label("Awards", systemImage: "rosette").tag(4)
                }.accentColor(.redditBlue)
                
            }
            .listStyle(SidebarListStyle())
            
            NavigationView {
                if sidebarSelection.first == 1 {
                    UserSheetOverviewView(viewModel: viewModel)
                } else if sidebarSelection.first == 2 {
                    if let posts = viewModel.submittedPosts {
                        PostsListView(posts: posts, displayMode: .constant(.large)) {
                            viewModel.fetchSubmitted(after: posts.last)
                        }
                    }
                } else if sidebarSelection.first == 3 {
                    UserSheetCommentsView(viewModel: viewModel)
                }
                
                PostNoSelectionPlaceholder()
            }
        }
        .frame(width: 1500, height: 700)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                }
            }
        }
    }
}

struct UserSheetView_Previews: PreviewProvider {
    static var previews: some View {
        UserSheetView(user: static_user)
    }
}
