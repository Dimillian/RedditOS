//
//  SubredditRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct SubredditRow: View {
    let subreddit: Subreddit
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let image = subreddit.iconImg,
                   let url = URL(string: image) {
                    WebImage(url: url)
                        .resizable()
                        .frame(width: 30, height: 30)
                } else {
                    RoundedRectangle(cornerRadius: 15,
                                     style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading) {
                    Text(subreddit.name)
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Subscribers: \(subreddit.subscriberCount)")
                }
            }
            Divider()
        }
    }
}

struct SubredditRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SubredditRow(subreddit: static_subreddit)
            SubredditRow(subreddit: static_subreddit)
            SubredditRow(subreddit: static_subreddit)
            SubredditRow(subreddit: static_subreddit)
        }
    }
}
