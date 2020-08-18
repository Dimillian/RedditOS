//
//  SubredditAboutPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 11/08/2020.
//

import SwiftUI
import Backend

struct SubredditAboutPopoverView: View {
    @EnvironmentObject private var localData: LocalDataStore
    @ObservedObject var viewModel: SubredditViewModel
    @State private var isSubscribeHovered = false
    
    var isFavorite: Bool {
        guard let subreddit = viewModel.subreddit else {
            return false
        }
        return localData.favorites.contains(SubredditSmall.makeSubredditSmall(with: subreddit))
    }
    
    var isSubscriber: Bool {
        viewModel.subreddit?.userIsSubscriber == true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    if let subreddit = viewModel.subreddit {
                        Button(action: {
                            viewModel.toggleSubscribe()
                        }, label: {
                            if isSubscribeHovered {
                                Text(isSubscriber ? "Unsubscribe?" : "Subscribe?")
                            } else {
                                Text(isSubscriber ? "Subscribed" : "Subscribe")
                            }
                        }).onHover(perform: { hovering in
                            isSubscribeHovered = hovering
                        })
                        
                        Button(action: {
                            if isFavorite {
                                localData.remove(favorite: SubredditSmall.makeSubredditSmall(with: subreddit))
                            } else {
                                localData.add(favorite: SubredditSmall.makeSubredditSmall(with: subreddit))
                            }
                        }, label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(isFavorite ? .redditGold : nil)
                        }).buttonStyle(BorderlessButtonStyle())
                    }
                }
                Text("About Community")
                    .font(.title3)
                Text(viewModel.subreddit?.publicDescription ?? "")
                    .font(.body)
                if let subscribers = viewModel.subreddit?.subscribers,
                   let connected = viewModel.subreddit?.accountsActive {
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
                        Text(viewModel.subreddit?.createdUtc ?? Date(), style: .date)
                }
                
            }.padding()
        }.frame(width: 250, height: 350)
    }
}

struct SubredditAboutPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        SubredditAboutPopoverView(viewModel: SubredditViewModel(name: static_subreddit.name)).environmentObject(LocalDataStore())
    }
}
