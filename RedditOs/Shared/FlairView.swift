//
//  FlairView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/07/2020.
//

import SwiftUI
import Backend
import KingfisherSwiftUI

struct FlairView: View {
    enum Display {
        case small, normal
    }
    
    let richText: [FlairRichText]?
    let textColorHex: String?
    let backgroundColorHex: String?
    let display: Display
    
    var backgroundColor: Color {
        if let color = backgroundColorHex {
            if color.isEmpty {
                return .gray
            }
            return Color(hex: color)
        }
        return .redditBlue
    }
    
    var textColor: Color {
        if backgroundColor == .gray {
            return .white
        }
        return textColorHex == "dark" ? .black : .white
    }

    @ViewBuilder
    var body: some View {
        if let texts = richText {
            HStack(spacing: 4) {
                ForEach(texts, id: \.self) { text in
                    if text.e == "emoji" {
                        KFImage(text.u!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    } else if text.e == "text" {
                        Text(text.t!)
                            .foregroundColor(textColor)
                            .font(display == .small ? .footnote : .callout)
                            .fontWeight(.semibold)
                    } else {
                        EmptyView()
                    }
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(backgroundColor)
            )
        } else {
            EmptyView()
        }
    }
}

struct FlairView_Previews: PreviewProvider {
    static var previews: some View {
        FlairView(richText: nil,
                  textColorHex: nil,
                  backgroundColorHex: "#dadada",
                  display: .normal)
    }
}
