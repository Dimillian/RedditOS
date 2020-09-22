//
//  PostDetailToolbar.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 21/09/2020.
//

import SwiftUI

struct PostDetailToolbar: ToolbarContent {
    let shareURL: URL?
        
    var body: some ToolbarContent {
        ToolbarItemGroup {
            SharingView(url: shareURL)
            Spacer()
            ToolbarSearchBar()
        }
    }
}

struct SharingView: View {
    let url: URL?
    @State private var sharePickerShown = false
    
    var body: some View {
        Button(action: {
            sharePickerShown.toggle()
        }) {
            Image(systemName: "square.and.arrow.up")
        }.background(SharingsPicker(isPresented: $sharePickerShown,
                                    sharingItems: [url ?? ""]))
        
    }
}
