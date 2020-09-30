//
//  Sidebar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI
import Backend

struct SidebarView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var localData: LocalDataStore
    @EnvironmentObject private var currentUser: CurrentUserStore
    
    @State private var isSearchPopoverPresented = false
    @State private var isHovered = false
    @State private var isInEditMode = false
    
    var body: some View {
        List(selection: $uiState.sidebarSelection) {
            if let route = uiState.presentedNavigationRoute {
                Section {
                    NavigationLink(
                        destination: route.makeView(),
                        tag: route,
                        selection: $uiState.presentedNavigationRoute,
                        label: {
                            Label("Search", systemImage: "magnifyingglass")
                        })
                }
            }
            
            Section {
                ForEach(UIState.DefaultChannels.allCases, id: \.self) { item in
                    NavigationLink(destination: SubredditPostsListView(name: item.rawValue)) {
                        Label(LocalizedStringKey(item.rawValue.capitalized), systemImage: item.icon())
                    }.tag(item.rawValue)
                }.animation(nil)
            }
             
            Section(header: Text("Account")) {
                NavigationLink(destination: ProfileView()) {
                    if let user = currentUser.user {
                        Label(user.name, systemImage: "person.crop.circle")
                    } else {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                }.tag("profile")
                Label("Inbox", systemImage: "envelope")
                NavigationLink(destination: SubmittedPostsListView()) {
                    Label("Posts", systemImage: "square.and.pencil")
                }.tag("Posts")
                Label("Comments", systemImage: "text.bubble")
                NavigationLink(destination: SavedPostsListView()) {
                    Label("Saved", systemImage: "archivebox")
                }.tag("Saved")
            }.listItemTint(.redditBlue)
            
            Section(header: subredditsHeader) {
                ForEach(localData.favorites) { reddit in
                    HStack {
                        SidebarSubredditRow(name: reddit.name,
                                            iconURL: reddit.iconImg)
                            .tag("local\(reddit.name)")
                        if isInEditMode {
                            Spacer()
                            Button {
                                localData.remove(favorite: reddit)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }.animation(nil)
            }
            .listItemTint(.redditGold)
            .animation(.easeInOut)
                        
            if let subs = currentUser.subscriptions, currentUser.user != nil {
                Section(header: Text("Subscriptions")) {
                    ForEach(subs) { reddit in
                        HStack {
                            SidebarSubredditRow(name: reddit.displayName,
                                                iconURL: reddit.iconImg)
                                .tag(reddit.displayName)
                            Spacer()
                            if isHovered {
                                let isfavorite = localData.favorites.first(where: { $0.name == reddit.displayName}) != nil
                                Button {
                                    if isfavorite {
                                        localData.remove(favoriteNamed: reddit.displayName)
                                    } else {
                                        localData.add(favorite: SubredditSmall.makeSubredditSmall(with: reddit))
                                    }
                                } label: {
                                    Image(systemName: isfavorite ? "star.fill" : "star")
                                        .imageScale(.large)
                                        .foregroundColor(.yellow)
                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }.animation(nil)
                }.listItemTint(.redditBlue)
            }
        }
        .animation(nil)
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, maxHeight: .infinity)
        .onHover { hovered in
            isHovered = hovered
        }
    }
    
    private var subredditsHeader: some View {
        HStack(spacing: 8) {
            Text("Favorites")
            if isHovered {
                Button {
                    isSearchPopoverPresented = true
                } label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                .popover(isPresented: $isSearchPopoverPresented) {
                    PopoverSearchSubredditView()
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
        SidebarView()
    }
}
