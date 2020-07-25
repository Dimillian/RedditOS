//
//  PostNoSelectionPlaceholder.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 25/07/2020.
//

import SwiftUI

struct PostNoSelectionPlaceholder: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("No post selected")
                .font(.headline)
                .fontWeight(.bold)
            Image(systemName: "bolt.slash")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .frame(minWidth: 500,
               maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct PostNoSelectionPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        PostNoSelectionPlaceholder()
    }
}
