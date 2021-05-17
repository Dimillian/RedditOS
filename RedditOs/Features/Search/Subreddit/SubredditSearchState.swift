//
//  SubredditSearchState.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI
import Combine

class SubredditSearchState: ObservableObject {
    @Published var searchText: String = ""
}
