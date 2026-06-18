import Cocoa
import SwiftUI

extension KeyboardConfig {
    var textColor: Color? {
        get {
            if let hex = textColorHex {
                return Color(hex: hex)
            } else {
                return nil
            }
        }

        set {
            guard let newValue = newValue else {
                textColorHex = nil
                return
            }

            if #available(macOS 11.0, *) {
                textColorHex = newValue.hexWithAlpha
            }
        }
    }

    var textNSColor: NSColor? {
        get {
            if let hex = textColorHex {
                return NSColor(hex: hex)
            } else {
                return nil
            }
        }

        set {
            textColorHex = newValue?.hexWithAlpha
        }
    }

    var bgColor: Color? {
        get {
            if let hex = bgColorHex {
                return Color(hex: hex)
            } else {
                return nil
            }
        }

        set {
            guard let newValue = newValue else {
                bgColorHex = nil
                return
            }

            if #available(macOS 11.0, *) {
                bgColorHex = newValue.hexWithAlpha
            }
        }
    }

    var bgNSColor: NSColor? {
        get {
            if let hex = bgColorHex {
                return NSColor(hex: hex)
            } else {
                return nil
            }
        }

        set {
            bgColorHex = newValue?.hexWithAlpha
        }
    }
}
