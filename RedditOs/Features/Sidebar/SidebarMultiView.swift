import SwiftUI
import Backend
import UI


struct SidebarMultiView: View {
    @State private var isExpanded = false
    
    let multi: Multi
    
    var body: some View {
        HStack {
            Button(action: {
                isExpanded.toggle()
            }, label: {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.forward")
            })
            .buttonStyle(BorderlessButtonStyle())
            NavigationLink(destination:
                            SubredditPostsListView(name: multi.subredditsAsName,
                                                   customTitle: multi.displayName)
                                                  .equatable()) {
                                      Text(multi.displayName)
                                  }
        }
        if isExpanded {
            ForEach(multi.subreddits) { subreddit in
                HStack {
                    NavigationLink(destination: SubredditPostsListView(name: subreddit.name)
                                    .equatable()) {
                        Text(subreddit.name)
                    }
                    .padding(.leading, 8)
                }
            }
        }
    }
}
