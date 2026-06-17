//
//  ISPTextEditor.swift
//  Input Source Pro
//
//  Created by runjuu on 2023-03-05.
//

import SwiftUI

private struct ISPTextView: NSViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = false

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.isRichText = false
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        textView.textColor = NSColor.labelColor
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.string = text
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )

        scrollView.documentView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView,
              textView.string != text
        else { return }

        textView.string = text
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }
}

struct ISPTextEditor: View {
    @Binding var text: String

    var placeholder: String

    let minHeight: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            ISPTextView(text: $text)
                .padding(.vertical, 7)
                .padding(.horizontal, 2)
                .frame(minHeight: minHeight, maxHeight: 500, alignment: .leading)
                .foregroundColor(Color(.labelColor))
                .multilineTextAlignment(.leading)
                .background(Color(NSColor.textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                )

            Text(placeholder)
                .padding(.vertical, 7)
                .padding(.horizontal, 7)
                .foregroundColor(Color(.placeholderTextColor))
                .opacity(text.isEmpty ? 1 : 0)
                .allowsHitTesting(false)
        }
        .font(.body)
    }
}
