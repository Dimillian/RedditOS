//
//  PostAwardView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 05/08/2020.
//

import SwiftUI
import Backend
import KingfisherSwiftUI

struct AwardsView: View {
    let awards: [Award]
    
    @State private var popoverPresented = false
    @State private var descriptionPopoverPresented = false
    
    var body: some View {
        HStack {
            ForEach(awards.prefix(3)) { award in
                HStack(spacing: 2) {
                    KFImage(award.staticIconUrl)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            Text("\(awards.map{ $0.count }.reduce(0, +))")
                .foregroundColor(.gray)
                .font(.footnote)
        }
        .onTapGesture(count: 1, perform: {
            popoverPresented = true
        })
        .popover(isPresented: $popoverPresented, content: {
            ScrollView {
                VStack {
                    ForEach(awards) { award in
                        HStack(spacing: 8) {
                            KFImage(award.staticIconUrl)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(award.name)
                            Spacer()
                            Text("\(award.count)")
                        }
                        Divider()
                    }
                }.padding()
            }.frame(width: 250, height: 300)
        })
    }
}

struct PostAwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView(awards: [static_award, static_award,
                                static_award, static_award,
                                static_award, static_award])
    }
}
