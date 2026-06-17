import AVKit
import SwiftUI

struct AppearanceSettingsView: View {
    @EnvironmentObject var preferencesVM: PreferencesVM
    @EnvironmentObject var navigationVM: NavigationVM

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State private var width = CGFloat.zero

    var body: some View {
        let infoBinding = Binding(
            get: {
                preferencesVM.preferences.indicatorInfo ?? .iconAndTitle
            },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    preferencesVM.update {
                        $0.indicatorInfo = newValue
                    }
                }
            }
        )

        let sizeBinding = Binding(
            get: {
                preferencesVM.preferences.indicatorSize ?? .medium
            },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    preferencesVM.update {
                        $0.indicatorSize = newValue
                    }
                }
            }
        )

        let forgegroundColorBinding = Binding(
            get: {
                preferencesVM.preferences.indicatorForgegroundNSColor
            },
            set: { newValue in
                preferencesVM.update {
                    $0.indicatorForgegroundNSColor = newValue
                }
            }
        )

        let backgroundColorBinding = Binding(
            get: {
                preferencesVM.preferences.indicatorBackgroundNSColor
            },
            set: { newValue in
                preferencesVM.update {
                    $0.indicatorBackgroundNSColor = newValue
                }
            }
        )

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                SettingsSection(title: "Indicator Info") {
                    VStack(spacing: 0) {
                        ItemSection {
                            IndicatorView()
                        }
                        .frame(height: 100)
                        .padding(.horizontal)
                        .padding(.top)

                        Picker("Position", selection: infoBinding) {
                            ForEach(IndicatorInfo.allCases) { item in
                                Text(item.name).tag(item)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                }

                SettingsSection(title: "Indicator Size") {
                    Picker("Size", selection: sizeBinding) {
                        ForEach(IndicatorSize.allCases) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                SettingsSection(title: "Color Scheme") {
                    VStack(spacing: 0) {
                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isAutoAppearanceMode)
                                .toggleStyle(SwitchToggleStyle())
                                .labelsHidden()

                            Text("Sync with OS".i18n())

                            Spacer()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        VStack(spacing: 16) {
                            Picker("", selection: $preferencesVM.preferences.appearanceMode) {
                                Text("In Light Mode".i18n()).tag(Optional(Preferences.AppearanceMode.light))
                                Text("In Dark Mode".i18n()).tag(Optional(Preferences.AppearanceMode.dark))
                            }
                            .labelsHidden()
                            .pickerStyle(SegmentedPickerStyle())

                            ColorBlocks(
                                onSelectColor: { scheme in
                                    preferencesVM.update {
                                        $0.indicatorForgegroundNSColor = NSColor(hex: scheme.textHex)
                                        $0.indicatorBackgroundNSColor = NSColor(hex: scheme.backgroundHex)
                                    }
                                }
                            )

                            ItemSection {
                                IndicatorView()

                                HStack {
                                    CompatColorPicker(
                                        "Color",
                                        selection: forgegroundColorBinding
                                    )
                                    .labelsHidden()

                                    Button(
                                        action: {
                                            preferencesVM.update {
                                                let a = $0.indicatorForgegroundNSColor
                                                let b = $0.indicatorBackgroundNSColor

                                                $0.indicatorForgegroundNSColor = b
                                                $0.indicatorBackgroundNSColor = a
                                            }
                                        },
                                        label: {
                                            Image.compatSystemName("repeat")
                                        }
                                    )

                                    CompatColorPicker(
                                        "Background",
                                        selection: backgroundColorBinding
                                    )
                                    .labelsHidden()
                                }
                            }
                            .frame(height: 130)
                        }
                        .padding()
                    }
                }
            }
            .padding()
            .padding(.bottom)
        }
        .background(NSColor.background1.color)
        .onAppear(perform: updatePreviewModeOnAppear)
        .onDisappear {
            NSColorPanel.shared.close()
        }
    }

    func updatePreviewModeOnAppear() {
        if preferencesVM.preferences.isAutoAppearanceMode {
            preferencesVM.preferences.appearanceMode = colorScheme == .dark ? .dark : .light
        }
    }

    func resetColors() {
        if preferencesVM.preferences.appearanceMode == .light {
            preferencesVM.preferences.indicatorForgegroundNSColor = NSColor(hex: IndicatorColor.forgeground.lightHex)
            preferencesVM.preferences.indicatorBackgroundNSColor = NSColor(hex: IndicatorColor.background.lightHex)
        }

        if preferencesVM.preferences.appearanceMode == .dark {
            preferencesVM.preferences.indicatorForgegroundNSColor = NSColor(hex: IndicatorColor.forgeground.darkHex)
            preferencesVM.preferences.indicatorBackgroundNSColor = NSColor(hex: IndicatorColor.background.darkHex)
        }
    }
}
