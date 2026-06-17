import SwiftUI
import VisualEffects

struct KeyboardCustomization: View {
    @EnvironmentObject var preferencesVM: PreferencesVM

    @State var textColor: NSColor = .clear
    @State var bgColor: NSColor = .clear
    @State private var keyboardConfig: KeyboardConfig?

    let inputSource: InputSource

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack(spacing: 16) {
                    indicatorPreview(
                        kind: .alwaysOn,
                        title: "Always-On Indicator Style"
                    )

                    indicatorPreview(
                        kind: preferencesVM.preferences.indicatorKind,
                        title: "Keyboard Indicator Style"
                    )
                }
                .padding()
                .itemSectionStyle()

                VStack {
                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: { reset(keyboardConfig) }) {
                            Text("Reset")
                        }
                        .buttonStyle(GhostButton(icon: Image.compatSystemName("arrow.clockwise")))
                    }
                }
                .padding(.trailing, 4)
                .padding(.bottom, 4)
            }

            VStack(alignment: .center) {
                ColorBlocks(onSelectColor: {
                    textColor = NSColor(hex: $0.textHex)
                    bgColor = NSColor(hex: $0.backgroundHex)
                })
                .padding(.vertical, 8)

                HStack {
                    CompatColorPicker("Color", selection: $textColor)

                    Button(
                        action: {
                            let a = textColor
                            let b = bgColor

                            textColor = b
                            bgColor = a
                        },
                        label: {
                            Image.compatSystemName("repeat")
                        }
                    )

                    CompatColorPicker("Background", selection: $bgColor)
                }
                .labelsHidden()
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            keyboardConfig = preferencesVM.getKeyboardConfig(inputSource)
            textColor = preferencesVM.getTextNSColor(inputSource) ?? preferencesVM.preferences.indicatorForgegroundNSColor
            bgColor = preferencesVM.getBgNSColor(inputSource) ?? preferencesVM.preferences.indicatorBackgroundNSColor
        }
        .onChangeCompat(of: bgColor.hexWithAlpha, perform: { _ in save() })
        .onChangeCompat(of: textColor.hexWithAlpha, perform: { _ in save() })
        .onDisappear {
            NSColorPanel.shared.close()
        }
    }

    func indicatorPreview(kind: IndicatorKind, title: String) -> some View {
        VStack(spacing: 8) {
            DumpIndicatorView(config: IndicatorViewConfig(
                inputSource: inputSource,
                kind: kind,
                size: preferencesVM.preferences.indicatorSize ?? .medium,
                bgColor: bgColor,
                textColor: textColor
            ))

            Text(title)
                .font(.caption)
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity)
    }

    func save() {
        let config = keyboardConfig ?? preferencesVM.getOrCreateKeyboardConfig(inputSource)
        keyboardConfig = config
        preferencesVM.update(config, textColor: textColor, bgColor: bgColor)
    }

    func reset(_: KeyboardConfig?) {
        bgColor = preferencesVM.preferences.indicatorBackgroundNSColor
        textColor = preferencesVM.preferences.indicatorForgegroundNSColor
    }
}
