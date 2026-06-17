import SwiftUI

struct IndicatorColor {
    let lightHex: String
    let darkHex: String

    var light: Color {
        Color(hex: lightHex)
    }

    var dark: Color {
        Color(hex: darkHex)
    }

    init(light: Color, dark: Color) {
        self.init(lightHex: light.hexWithAlpha, darkHex: dark.hexWithAlpha)
    }

    init(lightHex: String, darkHex: String) {
        self.lightHex = lightHex
        self.darkHex = darkHex
    }
}

extension IndicatorColor {
    var dynamicColor: NSColor {
        return NSColor(name: nil) { appearance in
            switch appearance.bestMatch(from: [.darkAqua]) {
            case .darkAqua?:
                return NSColor(hex: self.darkHex)
            default:
                return NSColor(hex: self.lightHex)
            }
        }
    }
}

extension IndicatorColor {
    static let background = IndicatorColor(
        lightHex: "fffffff2",
        darkHex: "000000ff"
    )

    static let forgeground = IndicatorColor(
        lightHex: "000000ff",
        darkHex: "ffffffff"
    )
}

extension IndicatorColor: Codable {
    private enum CodingKeys: String, CodingKey { case light, dark }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lightStr = try container.decode(String.self, forKey: .light)
        let darkStr = try container.decode(String.self, forKey: .dark)

        lightHex = lightStr
        darkHex = darkStr
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lightHex, forKey: .light)
        try container.encode(darkHex, forKey: .dark)
    }
}
