//
//  SharingPicker.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 12/08/2020.
//

import Foundation
import AppKit
import SwiftUI

struct SharingsPicker: NSViewRepresentable {
    @Binding var isPresented: Bool
    var sharingItems: [Any] = []
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if isPresented {
            let picker = NSSharingServicePicker(items: sharingItems)
            picker.delegate = context.coordinator
            DispatchQueue.main.async {
                picker.show(relativeTo: .zero, of: nsView, preferredEdge: .minY)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }
    
    class Coordinator: NSObject, NSSharingServicePickerDelegate {
        let owner: SharingsPicker
        
        init(owner: SharingsPicker) {
            self.owner = owner
        }
        
        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            sharingServicePicker.delegate = nil
            self.owner.isPresented = false
        }
    }
}
