//
//  Sidebar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI
import Backend

struct Sidebar: View {
    @EnvironmentObject private var localData: PersistedContent
    @EnvironmentObject private var currentUser: CurrentUser
    @StateObject private var viewModel = SidebarViewModel()
    @State private var isSearchPopoverPresented = false
    @State private var isFavoritesSectionHovered = false
    @State private var isInEditMode = false
    
    var body: some View {
        List(selection: $viewModel.selection) {
            ForEach(SidebarViewModel.MainSubreddits.allCases, id: \.self) { item in
                NavigationLink(destination: SubredditPostsListView(name: item.rawValue)) {
                    Label(LocalizedStringKey(item.rawValue.capitalized), systemImage: item.icon())
                }.tag(item.rawValue)
            }
             
            Group {
                Text("Account").foregroundColor(.gray)
                NavigationLink(destination: ProfileView()) {
                    Label("Profile", systemImage: "person.crop.square")
                }.tag("profile")
                Label("Inbox", systemImage: "envelope")
                Label("Posts", systemImage: "square.and.pencil")
                Label("Comments", systemImage: "text.bubble")
                Label("Saved", systemImage: "archivebox")
            }.listItemTint(Color("RedditBlue"))
            
            Group {
                subredditsHeader.foregroundColor(.gray)
                ForEach(localData.subreddits) { reddit in
                    HStack {
                        NavigationLink(destination: SubredditPostsListView(name: reddit.name)) {
                            Label(reddit.name.capitalized, systemImage: "star")
                        }.tag("local\(reddit.name)")
                        if isInEditMode {
                            Spacer()
                            Button {
                                localData.subreddits.removeAll(where: { $0 == reddit })
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
            .listItemTint(Color("RedditGold"))
            .animation(.easeInOut)
                        
            if let subs = currentUser.subscriptions {
                Group {
                    Text("Subscriptions").foregroundColor(.gray)
                    ForEach(subs) { reddit in
                        HStack {
                            NavigationLink(destination: SubredditPostsListView(name: reddit.name)) {
                                Label(reddit.name.capitalized, systemImage: "globe")
                            }.tag(reddit.name)
                        }
                    }
                }.listItemTint(Color("RedditBlue"))
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 150, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
        .onHover { hovered in
            isFavoritesSectionHovered = hovered
        }
        .padding(.top, 16)
    }
    
    private var subredditsHeader: some View {
        HStack(spacing: 8) {
            Text("Favorites")
            if isFavoritesSectionHovered {
                Button {
                    isSearchPopoverPresented = true
                } label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                .popover(isPresented: $isSearchPopoverPresented) {
                    SearchSubredditsPopover().environmentObject(localData)
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
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
