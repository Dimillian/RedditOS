//
//  SidebarTabView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI

struct SidebarTabView: View {
    @State private var items = ["Home", "Favorites", "Subscriptions", "Recently", "Multireddits"]
    @State private var enabled = true
    var body: some View {
        Form {
            Section(header: Text("Sidebar items")) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Toggle(isOn: $enabled) {
                            Text(item)
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 400, height: 300)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

struct SidebarTabView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarTabView()
    }
}

