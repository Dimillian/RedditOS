//
//  Sidebar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI

struct Sidebar: View {
    @StateObject private var viewModel = SidebarViewModel()
    
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
                Label("r/games", systemImage: "globe")
                Label("r/gaming", systemImage: "globe")
                Label("r/fun", systemImage: "globe")
                Label("r/Diablo", systemImage: "globe")
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
                
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .foregroundColor(.blue)
            }.buttonStyle(BorderlessButtonStyle())

        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
