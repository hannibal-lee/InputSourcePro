import AppKit
import Combine
import SwiftUI

struct CompatColorPicker: View {
    let titleKey: LocalizedStringKey
    @Binding var selection: NSColor

    init(_ titleKey: LocalizedStringKey, selection: Binding<NSColor>) {
        self.titleKey = titleKey
        _selection = selection
    }

    var body: some View {
        HStack(spacing: 6) {
            CompatColorWell(selection: $selection)
                .frame(width: 42, height: 24)

            Text(titleKey)
        }
    }
}

private struct CompatColorWell: NSViewRepresentable {
    @Binding var selection: NSColor

    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }

    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell(frame: .zero)
        colorWell.isBordered = true
        colorWell.color = selection
        colorWell.target = context.coordinator
        colorWell.action = #selector(Coordinator.colorDidChange(_:))
        return colorWell
    }

    func updateNSView(_ nsView: NSColorWell, context _: Context) {
        guard !nsView.color.isEqual(selection) else { return }
        nsView.color = selection
    }

    final class Coordinator: NSObject {
        @Binding var selection: NSColor

        init(selection: Binding<NSColor>) {
            _selection = selection
        }

        @objc
        func colorDidChange(_ sender: NSColorWell) {
            selection = sender.color.normalizedRGBColor
        }
    }
}

extension NSColor {
    var color: Color {
        Color(self)
    }

    static var background: NSColor {
        if #available(macOS 10.14, *) {
            return .windowBackgroundColor
        }
        return .white
    }

    static var background1: NSColor {
        if #available(macOS 10.14, *) {
            return .controlBackgroundColor
        }
        return NSColor(calibratedWhite: 0.96, alpha: 1)
    }

    static var background2: NSColor {
        if #available(macOS 10.14, *) {
            return .textBackgroundColor
        }
        return .white
    }

    static var border: NSColor {
        .separatorColor
    }

    static var border2: NSColor {
        .gridColor
    }

    static var close: NSColor {
        NSColor(calibratedRed: 1.0, green: 0.38, blue: 0.34, alpha: 1)
    }

    static var minimise: NSColor {
        NSColor(calibratedRed: 1.0, green: 0.74, blue: 0.18, alpha: 1)
    }

    static var maximise: NSColor {
        NSColor(calibratedRed: 0.16, green: 0.79, blue: 0.25, alpha: 1)
    }

    var normalizedRGBColor: NSColor {
        usingColorSpace(.sRGB) ?? usingColorSpace(.deviceRGB) ?? self
    }
}

extension Image {
    static func compatSystemName(_ systemName: String) -> Image {
        if #available(macOS 11.0, *) {
            return Image(systemName: systemName)
        }

        let fallbackName: String
        switch systemName {
        case "slider.horizontal.3":
            fallbackName = "≡"
        case "square.grid.2x2":
            fallbackName = "▦"
        case "safari":
            fallbackName = "◎"
        case "arrow.up.and.down.and.arrow.left.and.right":
            fallbackName = "↕"
        case "paintbrush", "paintpalette":
            fallbackName = "■"
        case "command":
            fallbackName = "⌘"
        case "keyboard":
            fallbackName = "⌨"
        case "ladybug":
            fallbackName = "!"
        case "plus", "plus.circle":
            fallbackName = "+"
        case "minus":
            fallbackName = "-"
        case "checkmark", "checkmark.circle.fill":
            fallbackName = "✓"
        case "x.circle.fill":
            fallbackName = "x"
        case "questionmark":
            fallbackName = "?"
        case "repeat", "arrow.clockwise":
            fallbackName = "↻"
        case "chevron.down":
            fallbackName = "⌄"
        case "arrow.up.forward.square", "square.and.arrow.up.fill":
            fallbackName = "↗"
        case "eye.slash.circle.fill":
            fallbackName = "○"
        case "exclamationmark.triangle.fill":
            fallbackName = "!"
        case "video":
            fallbackName = "▶"
        case "star.fill":
            fallbackName = "★"
        case "heart.fill":
            fallbackName = "♥"
        case "circle":
            fallbackName = "○"
        case "app.dashed":
            fallbackName = "□"
        case "textformat":
            fallbackName = "T"
        case "d.circle.fill", "d.square.fill":
            fallbackName = "D"
        case "arrow.uturn.left.circle.fill":
            fallbackName = "↶"
        case "sun.max":
            fallbackName = "☀"
        default:
            fallbackName = ""
        }

        return Image(nsImage: textImage(fallbackName))
    }

    private static func textImage(_ text: String) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size)
        image.lockFocus()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14, weight: .semibold),
            .paragraphStyle: style,
            .foregroundColor: NSColor.labelColor,
        ]
        (text as NSString).draw(in: NSRect(origin: .zero, size: size), withAttributes: attributes)
        image.unlockFocus()
        return image
    }
}

extension NSSavePanel {
    func setCompatAllowedFileTypes(_ fileTypes: [String]) {
        allowedFileTypes = fileTypes
    }
}

extension View {
    func onChangeCompat<Value: Equatable>(
        of value: Value,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        modifier(OnChangeCompatModifier(value: value, action: action))
    }
}

private struct OnChangeCompatModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (Value) -> Void

    @State private var previousValue: Value?

    func body(content: Content) -> some View {
        content
            .onReceive(Just(value)) { newValue in
                guard let oldValue = previousValue else {
                    previousValue = newValue
                    return
                }

                guard oldValue != newValue else { return }
                previousValue = newValue
                action(newValue)
            }
    }
}
