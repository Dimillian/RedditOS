//
//  Sidebar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct Sidebar: View {
    @EnvironmentObject private var userData: PersistedContent
    @StateObject private var viewModel = SidebarViewModel()
    @State private var isSearchPopoverPresented = false
    @State private var isInEditMode = false
    
    var body: some View {
        List(selection: $viewModel.selection) {
            ForEach(SidebarViewModel.MainSubreddits.allCases, id: \.self) { item in
                NavigationLink(destination: SubredditView(name: item.rawValue)) {
                    Label(LocalizedStringKey(item.rawValue.capitalized), systemImage: item.icon())
                }.tag(item.rawValue)
            }
 
            Divider()
            
            Group {
                Text("Account").foregroundColor(.gray)
                NavigationLink(destination: ProfileView()) {
                    Label("Profile", systemImage: "person.crop.square")
                }.tag("profile")
                Label("Inbox", systemImage: "envelope")
                Label("Posts", systemImage: "square.and.pencil")
                Label("Comments", systemImage: "bubble.middle.bottom.fill")
                Label("Saved", systemImage: "archivebox")
            }.listItemTint(Color("RedditGold"))
            
            Divider()
            
            Group {
                subredditsHeader.foregroundColor(.gray)
                ForEach(userData.subreddits) { reddit in
                    HStack {
                        NavigationLink(destination: SubredditView(name: reddit.name)) {
                            Label(reddit.name.capitalized, systemImage: "globe")
                        }.tag(reddit.name)
                        if isInEditMode {
                            Spacer()
                            Button {
                                userData.subreddits.removeAll(where: { $0 == reddit })
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            .listItemTint(Color("RedditBlue"))
            
            Divider()
            
            Group {
                Text("All subscriptions").foregroundColor(.gray)
                Text("Please sign in...").foregroundColor(.white)
            }
        }
        .listStyle(SidebarListStyle())
        .animation(.easeInOut)
        .frame(minWidth: 150, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
        .padding(.top, 16)
    }
    
    private var subredditsHeader: some View {
        HStack(spacing: 8) {
            Text("Favorites")
            Button {
                isSearchPopoverPresented = true
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
            .popover(isPresented: $isSearchPopoverPresented) {
                SearchSubredditsPopover().environmentObject(userData)
            }
                        
            Button {
                isInEditMode.toggle()
            } label: {
                Image(systemName: isInEditMode ? "trash.circle.fill" : "trash.circle")
                    .imageScale(.large)
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())

        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
