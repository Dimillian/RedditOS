//
//  PostDetail.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import SwiftUI

struct PostDetail: View {
    let title: String
    let comments = [Comment(children: true), Comment(), Comment(), Comment(), Comment()]
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Text("r/swiftUI")
                        .fontWeight(.bold)
                        .font(.subheadline)
                    Text("Posted by u/user 14 hours ago")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Text(title).font(.title)
                Text(text).font(.body)
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 400, height: 250)
                        .foregroundColor(.gray)
                    Spacer()
                }

                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.middle.bottom.fill")
                            .imageScale(.small)
                            .foregroundColor(.white)
                        Text("14 comments")
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.small)
                            .foregroundColor(.white)
                        Text("Share")
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "bookmark")
                            .imageScale(.small)
                            .foregroundColor(.white)
                        Text("Save")
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "flag")
                            .imageScale(.small)
                            .foregroundColor(.white)
                        Text("Report")
                    }
                    
                }
            }.padding(.bottom, 16)
            
            Section(header: Text("Comments")) {

            }
            
            OutlineGroup(comments, children: \.comments) { comment in
                VStack(alignment: .leading) {
                    Text(comment.user)
                    Text(comment.text)
                }
            }
        }
        .listStyle(InsetListStyle())
        .frame(minWidth: 250,
               maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct Comment: Identifiable {
    let id = UUID()
    let user = "u/user"
    let text = "Comment text"
    let comments: [Comment]?
    
    init(children: Bool = false) {
        if children {
            comments = [Comment(), Comment(), Comment()]
        } else {
            comments = []
        }
    }
}

let text =
"""
With the conference date now announced, it would be very awkward to walk into the podium to say for the third time: "We are on track for Diablo Immortal regional testing mid-2020."
The only way you can interpret mid-2020 at this point is if they meant it in terms of quarters. The middle of the year in quarterly fractions would be July and August plus the half of May and August (the last 15 days of May and the first 15 days of August.
So that leaves us with a specific range: May 15 - August 15 as the quarterly middle of the year.
However, can they dare to walk into that conference call without announcing: "We successfully launched the Diablo Immortal regional testing, and X amount of players are playing the game and submitting feedback. We expect Beta Testing broadly around [X] timeframe, and a launch some time in 2021. We expect revenues... yadda-yadda.
In short, launch the testing already!
"""

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(title: "Preview")
    }
}
