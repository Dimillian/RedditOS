//
//  SubredditRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend
import KingfisherSwiftUI

struct PopoverSearchSubredditRow: View {
    let subreddit: SubredditSmall
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let image = subreddit.iconImg,
                   let url = URL(string: image) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(15)
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
            PopoverSearchSubredditRow(subreddit: static_subreddit)
            PopoverSearchSubredditRow(subreddit: static_subreddit)
            PopoverSearchSubredditRow(subreddit: static_subreddit)
            PopoverSearchSubredditRow(subreddit: static_subreddit)
        }
    }
}
