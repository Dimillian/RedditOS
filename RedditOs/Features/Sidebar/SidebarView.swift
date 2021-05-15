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
            mainSection
            accountSection
            favoritesSection
            subscriptionSection
            multiSection
        }
        .animation(nil)
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, maxHeight: .infinity)
        .onHover { hovered in
            isHovered = hovered
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }
    
    private var subscriptionsHeader: some View {
        HStack(spacing: 8) {
            Text("Subscriptions")
            if currentUser.isRefreshingSubscriptions {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 15, height: 15)
                    .scaleEffect(0.5)
            }
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
    
    private var mainSection: some View {
        Section {
            NavigationLink(destination: SearchMainContentView(),
                           isActive: uiState.isSearchActive,
                           label: {
                            Label("Search", systemImage: "magnifyingglass")
                           })
                .tag(UIState.Constants.searchTag)
            
            ForEach(UIState.DefaultChannels.allCases, id: \.self) { item in
                NavigationLink(destination:
                                SubredditPostsListView(name: item.rawValue)
                                .equatable()) {
                    Label(LocalizedStringKey(item.rawValue.capitalized), systemImage: item.icon())
                }.tag(item.rawValue)
            }.animation(nil)
        }
    }
    
    private var accountSection: some View {
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
    }
    
    private var favoritesSection: some View {
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
    }
    
    @ViewBuilder
    private var subscriptionSection: some View {
        if currentUser.user != nil, (!currentUser.subscriptions.isEmpty || currentUser.isRefreshingSubscriptions) {
            Section(header: subscriptionsHeader) {
                ForEach(currentUser.subscriptions) { reddit in
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
    
    @ViewBuilder
    private var multiSection: some View {
        if currentUser.user != nil && !currentUser.multi.isEmpty {
            Section(header: Text("Multireddits")) {
                ForEach(currentUser.multi) { multi in
                    DisclosureGroup {
                        ForEach(multi.subreddits) { subreddit in
                            NavigationLink(destination: SubredditPostsListView(name: subreddit.name)
                                            .equatable()) {
                                Text(subreddit.name)
                            }
                        }
                    } label: {
                        NavigationLink(destination: SubredditPostsListView(name: multi.subredditsAsName,
                                                                           customTitle: multi.displayName)
                                        .equatable()) {
                            Text(multi.displayName)
                        }
                    }
                }
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
