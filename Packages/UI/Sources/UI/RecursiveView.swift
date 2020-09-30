//
//  SwiftUIView.swift
//  
//
//  Created by Thomas Ricouard on 12/08/2020.
//

import SwiftUI

public struct RecursiveView<Data, RowContent>: View where Data: RandomAccessCollection,
                                                           Data.Element: Identifiable,
                                                           RowContent: View {
    let data: Data
    let children: KeyPath<Data.Element, Data?>
    let rowContent: (Data.Element) -> RowContent
    
    public init(data: Data, children: KeyPath<Data.Element, Data?>, rowContent: @escaping (Data.Element) -> RowContent) {
        self.data = data
        self.children = children
        self.rowContent = rowContent
    }
    
    public var body: some View {
        ForEach(data) { child in
            if self.containsSub(child)  {
                CustomDisclosureGroup(content: {
                    RecursiveView(data: child[keyPath: children]!,
                                  children: children,
                                  rowContent: rowContent)
                        .padding(.leading, 8)
                }, label: {
                    rowContent(child)
                })
            } else {
                rowContent(child)
            }
        }
    }
    
    func containsSub(_ element: Data.Element) -> Bool {
        element[keyPath: children] != nil
    }
}

struct CustomDisclosureGroup<Label, Content>: View where Label: View, Content: View {
    @State var isExpanded: Bool = true
    var content: () -> Content
    var label: () -> Label
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "chevron.right")
                .rotationEffect(isExpanded ? .degrees(90) : .degrees(0))
                .padding(.top, 4)
                .onTapGesture {
                    isExpanded.toggle()
                }
            label()
        }
        if isExpanded {
            content()
        }
    }
}
