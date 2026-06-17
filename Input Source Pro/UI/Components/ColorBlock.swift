import SwiftUI

struct ColorBlocks: View {
    struct Scheme {
        let textHex: String
        let backgroundHex: String

        var textColor: Color { Color(hex: textHex) }
        var backgroundColor: Color { Color(hex: backgroundHex) }
    }

    let onSelectColor: (Scheme) -> Void

    let colors: [Scheme] = [
        Scheme(textHex: "ffffffff", backgroundHex: "000000ff"),
        Scheme(textHex: "ffffffff", backgroundHex: "ef233cff"),
        Scheme(textHex: "ffffffff", backgroundHex: "f77f00ff"),
        Scheme(textHex: "000000ff", backgroundHex: "f6cb56ff"),
        Scheme(textHex: "ffffffff", backgroundHex: "2c6e49ff"),
        Scheme(textHex: "ffffffff", backgroundHex: "0c7489ff"),
        Scheme(textHex: "ffffffff", backgroundHex: "023e8aff"),
        Scheme(textHex: "ffffffff", backgroundHex: "7209b7ff"),
    ]

    var body: some View {
        HStack {
            ForEach(Array(zip(colors.indices, colors)), id: \.0) { _, scheme in
                Spacer()
                ColorBlock(colorA: scheme.textColor, colorB: scheme.backgroundColor)
                    .onTapGesture {
                        onSelectColor(scheme)
                    }
                Spacer()
            }
        }
    }
}

struct ColorBlock: View {
    let colorA: Color

    let colorB: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(colorB)
            .overlay(
                SwiftUI.Image.compatSystemName("textformat")
                    .foregroundColor(colorA)
                    .font(.system(size: 12, weight: .semibold))
            )
            .frame(width: 28, height: 20)
    }
}
