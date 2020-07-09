//
//  Sidebar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI

struct Sidebar: View {
    @State private var selection: Set<Int> = [0]
    var body: some View {
        List(selection: $selection) {
            NavigationLink(destination: Listing()) {
                Label("Best", systemImage: "airplane")
            }.tag(0)
            Label("Hot", systemImage: "flame.fill").tag(1)
            Label("New", systemImage: "calendar.circle")
            Label("Top", systemImage: "chart.bar.fill")
 
            Section(header: Text("Account")) {
                Label("Profile", systemImage: "person.crop.square")
                Label("Inbox", systemImage: "envelope")
                Label("Posts", systemImage: "square.and.pencil")
                Label("Comments", systemImage: "bubble.middle.bottom.fill")
                Label("Saved", systemImage: "archivebox")
            }.listItemTint(Color("RedditGold"))
            
            Section(header: subredditsHeader) {
                Label("r/games", systemImage: "globe")
                Label("r/gaming", systemImage: "globe")
                Label("r/fun", systemImage: "globe")
                Label("r/Diablo", systemImage: "globe")
            }.listItemTint(Color("RedditBlue"))
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 100, idealWidth: 150, maxWidth: 200, maxHeight: .infinity)
        .padding(.top, 16)
    }
    
    private var subredditsHeader: some View {
        HStack {
            Text("Subreddits").font(.headline)
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
