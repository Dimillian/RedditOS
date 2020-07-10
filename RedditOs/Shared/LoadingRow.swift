//
//  LoadingRow.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI

struct LoadingRow: View {
    let text: String?
    
    var body: some View {
        HStack {
            Spacer()
            if let text = text {
                ProgressView(text)
            } else {
                ProgressView()
            }
            Spacer()
        }
    }
}

struct LoadingRow_Previews: PreviewProvider {
    static var previews: some View {
        LoadingRow(text: nil)
    }
}
