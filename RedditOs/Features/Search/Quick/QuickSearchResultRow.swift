//
//  GlobalSearchSubRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 06/08/2020.
//

import SwiftUI
import Kingfisher
import UI

struct QuickSearchResultRow: View {
    struct TextViewContainer: View {
        @State private var isHovered = false
        
        let text: String
        
        var body: some View {
            Text(text)
                .foregroundColor(isHovered ? .accentColor : nil)
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .whenHovered({ hovered  in
                    isHovered = hovered
                })
                .animation(.interactiveSpring(), value: isHovered)
        }
    }
    
    let icon: String?
    let name: String
        
    var defaultImage: some View {
        Image(systemName: "globe")
            .resizable()
            .frame(width: 16, height: 16)
    }
    
    var body: some View {
        HStack {
            if let image = icon,
               let url = URL(string: image) {
                KFImage(url)
                    .placeholder{ defaultImage }
                    .resizable()
                    .frame(width: 16, height: 16)
                    .cornerRadius(8)
            } else {
                defaultImage
            }
            TextViewContainer(text: name)
        }
    }
}
