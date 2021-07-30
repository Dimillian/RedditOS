//
//  Sidebar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI
import Backend
import UI

struct SidebarView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var localData: LocalDataStore
    @EnvironmentObject private var currentUser: CurrentUserStore
        
    @State private var isSearchPopoverPresented = false
    @State private var isHovered = false
    @State private var isInEditMode = false
    
    init() {
        
    }
    var body: some View {
        List(selection: $uiState.sidebarSelection) {
            mainSection
            accountSection
            recentlyVisitedSection
            favoritesSection
            subscriptionSection
            multiSection
        }
        .listStyle(.sidebar)
        .whenHovered({ hovered in
            isHovered = hovered
        })
        .toolbar {
            ToolbarItemGroup {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }
    
    
    private var subscriptionsHeader: some View {
        HStack(spacing: 8) {
            Text(SidebarItem.subscription.title())
            if currentUser.isRefreshingSubscriptions {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 15, height: 15)
                    .scaleEffect(0.5)
            }
        }
    }
    
    private var favoritesHeader: some View {
        HStack(spacing: 8) {
            Text(SidebarItem.favorites.title())
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
        Section(header: Text(SidebarItem.home.title())) {
            NavigationLink(destination: QuickSearchFullResultsView(),
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
            }.animation(nil, value: isHovered)
        }
    }
    
    private var accountSection: some View {
        Section(header: Text(SidebarItem.account.title())) {
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
        Section(header: favoritesHeader) {
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
            }.animation(nil, value: isHovered)
        }
        .listItemTint(.redditGold)
        .animation(.easeInOut, value: isHovered)
    }
    
    private var recentlyVisitedSection: some View {
        Section(header: Text(SidebarItem.recentlyVisited.title())) {
            ForEach(localData.recentlyVisited) { reddit in
                SidebarSubredditRow(name: reddit.name, iconURL: reddit.iconImg)
            }
        }
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
                }.animation(nil, value: isHovered)
            }.listItemTint(.redditBlue)
        }
    }
    
    @ViewBuilder
    private var multiSection: some View {
        if currentUser.user != nil && !currentUser.multi.isEmpty {
            Section(header: Text(SidebarItem.multi.title())) {
                ForEach(currentUser.multi) { multi in
                    SidebarMultiView(multi: multi)
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
