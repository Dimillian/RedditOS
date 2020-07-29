//
//  NSTextField.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 28/07/2020.
//

import Foundation
import AppKit

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
