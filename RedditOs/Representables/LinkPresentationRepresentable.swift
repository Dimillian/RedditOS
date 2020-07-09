//
//  LinkPresentationRepresentable.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 09/07/2020.
//

import Foundation
import LinkPresentation
import SwiftUI

public struct LinkPresentationView: NSViewRepresentable {
    public let url: URL
    @Binding var redraw: Bool
    
    public func makeNSView(context: Context) -> some NSView {
        let view = LPLinkView(url: url)
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { (metadata, error) in
            if let md = metadata {
                DispatchQueue.main.async {
                    view.metadata = md
                    redraw.toggle()
                }
            }
        }
        return view
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
