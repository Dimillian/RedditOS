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
    
    var body: some View {
        List(selection: $viewModel.selection) {
            ForEach(SidebarViewModel.MainSubreddits.allCases, id: \.self) { item in
                NavigationLink(destination: SubredditView(name: item.rawValue)) {
                    Label(LocalizedStringKey(item.rawValue.capitalized), systemImage: item.icon())
                }.tag(item.rawValue)
            }
 
            Divider()
            
            Group {
                Text("Account").foregroundColor(.white)
                Label("Profile", systemImage: "person.crop.square")
                Label("Inbox", systemImage: "envelope")
                Label("Posts", systemImage: "square.and.pencil")
                Label("Comments", systemImage: "bubble.middle.bottom.fill")
                Label("Saved", systemImage: "archivebox")
            }.listItemTint(Color("RedditGold"))
            
            Divider()
            
            Group {
                subredditsHeader.foregroundColor(.white)
                ForEach(userData.subreddits) { reddit in
                    NavigationLink(destination: SubredditView(name: reddit.name)) {
                        Label(LocalizedStringKey(reddit.name), systemImage: "globe")
                    }.tag(reddit.name)
                }
            }.listItemTint(Color("RedditBlue"))
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 150, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
        .padding(.top, 16)
    }
    
    private var subredditsHeader: some View {
        HStack {
            Text("Subreddits")
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

        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
