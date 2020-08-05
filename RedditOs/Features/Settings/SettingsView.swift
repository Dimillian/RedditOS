//
//  SettingsView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Text("General")
                .tabItem {
                    Image(systemName: "gearshape").imageScale(.large)
                    Text("General")
            }
            
            Text("Apperance")
                .tabItem {
                    Image(systemName: "textformat.alt").imageScale(.large)
                    Text("Apperance")
            }
            
            Text("Filters")
                .tabItem {
                    Image(systemName: "stop.circle").imageScale(.large)
                    Text("Filters")
            }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass").imageScale(.large)
                    Text("Search")
            }
            
            Text("Accounts")
                .tabItem {
                Image(systemName: "person").imageScale(.large)
                Text("Accounts")
            }
        }.frame(width: 1000, height: 500)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
