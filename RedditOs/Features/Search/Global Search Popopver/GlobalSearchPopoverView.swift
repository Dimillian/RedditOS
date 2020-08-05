//
//  GlobalSearchPopoverView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 05/08/2020.
//

import SwiftUI
import Backend
import SDWebImageSwiftUI

struct GlobalSearchPopoverView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var currentUser: CurrentUserStore
    
    @ObservedObject var viewModel: SubredditSearchViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                makeTitle("Quick access")
                makeQuickAccess()
                
                Divider()
                
                makeTitle("My subscriptions")
                makeMySubscriptionsSearch()
                
                Divider()
                
                makeTitle("Subreddit search")
                makeSubredditSearch()
                
            }.padding()
        }.frame(width: 300, height: 500)
    }
    
    private func makeTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
    }
    
    private func makeQuickAccess() -> some View {
        Group {
            Label("Go to r/\(viewModel.searchText)", systemImage: "globe")
                .onTapGesture {
                    uiState.searchedSubreddit = viewModel.searchText
                    uiState.displaySearch = true
                }
            Label("Go to u/\(viewModel.searchText)", systemImage: "person")
        }.padding(4)
    }
    
    private func makeMySubscriptionsSearch() -> some View {
        Group {
            let subs = currentUser.subscriptions.filter{ $0.displayName.lowercased().contains(viewModel.searchText.lowercased()) }
            if !subs.isEmpty {
                ForEach(subs) { sub in
                    makeSubRow(icon: sub.iconImg, name: sub.displayName)
                }
            } else {
                Label("No matching subscriptions for \(viewModel.searchText)", systemImage: "magnifyingglass")
            }
        }.padding(4)
    }
    
    private func makeSubredditSearch() -> some View {
        Group {
            if let results = viewModel.results {
                if results.isEmpty {
                    Label("No matching search for \(viewModel.searchText)", systemImage: "magnifyingglass")
                } else {
                    ForEach(results) { sub in
                        makeSubRow(icon: sub.iconImg, name: sub.name)
                    }
                }
            } else if viewModel.isLoading {
                LoadingRow(text: nil)
            }
        }.padding(4)
    }
    
    private func makeSubRow(icon: String?, name: String) -> some View {
        HStack {
            if let image = icon,
               let url = URL(string: image) {
                WebImage(url: url)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .cornerRadius(8)
            } else {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            Text(name)
        }
        .onTapGesture {
            uiState.searchedSubreddit = name
            uiState.displaySearch = true
        }
    }
}
