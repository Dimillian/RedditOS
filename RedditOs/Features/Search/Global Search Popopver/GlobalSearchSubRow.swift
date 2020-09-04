//
//  GlobalSearchSubRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 06/08/2020.
//

import SwiftUI
import KingfisherSwiftUI

struct GlobalSearchSubRow: View {
    let icon: String?
    let name: String
    
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            if let image = icon,
               let url = URL(string: image) {
                KFImage(url)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .cornerRadius(8)
            } else {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            Text(name).foregroundColor(isHovered ? .accentColor : nil)
        }
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.interactiveSpring())
        .onHover { hovered in
            isHovered = hovered
        }
    }
}
