//
//  Listing.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI

struct Listing: View {
    let posts = Array(repeating: 0, count: 20)
    
    @State private var search = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach((1...50), id: \.self) { _ in
                    NavigationLink(destination: PostDetail(title: "Check out my channel for Swift UI videos!")) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.gray)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Check out my channel for Swift UI videos!").fontWeight(.bold).font(.headline)
                                    HStack(spacing: 6) {
                                        Text("r/swiftUI")
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                        Text("Posted by u/user 14 hours ago")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    HStack(spacing: 6) {
                                        Image(systemName: "bubble.middle.bottom.fill")
                                            .imageScale(.small)
                                            .foregroundColor(.white)
                                        Text("14 comments")
                                    }
                                }
                            }
                        }.padding(.vertical, 8)
                    }
                }
            }
            .listStyle(InsetListStyle())
            .frame(minWidth: 300, maxHeight: .infinity)
            
            PostDetail(title: "Select a post")
        }
        .navigationTitle("r/swiftUI")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        Listing()
    }
}
