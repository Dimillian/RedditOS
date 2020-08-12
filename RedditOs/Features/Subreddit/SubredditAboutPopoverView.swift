//
//  SubredditAboutPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 11/08/2020.
//

import SwiftUI
import Backend

struct SubredditAboutPopoverView: View {
    let subreddit: Subreddit?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("About Community")
                    .font(.title3)
                Text(subreddit?.publicDescription ?? "")
                    .font(.body)
                if let subscribers = subreddit?.subscribers, let connected = subreddit?.accountsActive {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("\(subscribers.toRoundedSuffixAsString())")
                                .fontWeight(.bold)
                            Text("Members")
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(connected.toRoundedSuffixAsString())")
                                .fontWeight(.bold)
                            Text("Online")
                        }
                    }
                }
                
                Divider()
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar.circle")
                        .font(.title3)
                        .foregroundColor(.white)
                    Text(" Created ") +
                        Text(subreddit?.createdUtc ?? Date(), style: .date)
                }
                
            }.padding()
        }.frame(width: 250, height: 350)
    }
}

struct SubredditAboutPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        SubredditAboutPopoverView(subreddit: static_subreddit_full)
    }
}
