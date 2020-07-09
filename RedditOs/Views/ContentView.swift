//
//  ContentView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 08/07/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
            PostDetail(title: "Select a post")
        }.frame(minHeight: 800)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
