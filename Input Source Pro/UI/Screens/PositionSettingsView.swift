import AVKit
import SwiftUI

struct PositionSettingsView: View {
    @EnvironmentObject var preferencesVM: PreferencesVM
    @EnvironmentObject var navigationVM: NavigationVM
    @EnvironmentObject var permissionsVM: PermissionsVM

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State var displayIndicatorNearCursorTips = false
    @State var displayAlwaysOnIndicatorTips = false
    @State private var width = CGFloat.zero

    private var effectiveIndicatorPositionAlignment: IndicatorPosition.Alignment {
        preferencesVM.preferences.indicatorPositionAlignment ?? .bottomRight
    }

    private var needsScreenRecordingPermission: Bool {
        preferencesVM.preferences.indicatorPosition != .nearMouse &&
            !permissionsVM.isScreenRecordingEnabled
    }

    var body: some View {
        let sliderBinding = Binding(
            get: {
                Double(preferencesVM.preferences.indicatorPositionSpacing?.rawValue ?? 3)
            },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.2)) {
                    preferencesVM.update {
                        $0.indicatorPositionSpacing = .fromSlide(value: newValue)
                    }
                }
            }
        )

        let positionBinding = Binding(
            get: {
                preferencesVM.preferences.indicatorPosition ?? .nearMouse
            },
            set: { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    preferencesVM.update {
                        $0.indicatorPosition = newValue
                    }
                }
            }
        )

        ScrollView {
            VStack(spacing: 18) {
                SettingsSection(title: "Position") {
                    VStack(spacing: 0) {
                        IndicatorPositionEditor()
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(.horizontal)
                            .padding(.top)

                        Picker("Position", selection: positionBinding) {
                            ForEach(IndicatorPosition.allCases) { item in
                                Text(item.name).tag(item)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        if needsScreenRecordingPermission {
                            screenRecordingPermissionWarning
                        }

                        if preferencesVM.preferences.indicatorPosition != .nearMouse {
                            HStack {
                                Text("Spacing".i18n() + ":")
                                    .alignedView(width: $width, alignment: .leading)

                                HStack {
                                    Slider(value: sliderBinding, in: 0 ... 5, step: 1)

                                    if let name = preferencesVM.preferences.indicatorPositionSpacing?.name {
                                        Text(name)
                                            .foregroundColor(.primary)
                                            .frame(width: 50, height: 25)
                                            .background(Color.primary.opacity(0.05))
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .noAnimation()
                                    }
                                }
                            }
                            .padding()
                            .border(width: 1, edges: [.top, .bottom], color: NSColor.border2.color)

                            HStack {
                                Text("Alignment".i18n() + ":")
                                    .alignedView(width: $width, alignment: .leading)

                                HStack {
                                    PopUpButtonPicker<IndicatorPosition.Alignment>(
                                        items: IndicatorPosition.Alignment.allCases,
                                        isItemSelected: { $0 == effectiveIndicatorPositionAlignment },
                                        getTitle: { $0.name },
                                        getToolTip: { $0.name },
                                        onSelect: { index in
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                preferencesVM.update {
                                                    let value = IndicatorPosition.Alignment.allCases[index]
                                                    $0.indicatorPositionAlignment = value
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }

                SettingsSection(title: "Advanced", tips: EnhancedModeRequiredBadge()) {
                    VStack(spacing: 0) {
                        HStack {
                            Toggle(isOn: $preferencesVM.preferences.tryToDisplayIndicatorNearCursor) {}
                                .toggleStyle(SwitchToggleStyle())
                                .disabled(!preferencesVM.preferences.isEnhancedModeEnabled)

                            Text("tryToDisplayIndicatorNearCursor".i18n())

                            Spacer()

                            QuestionButton(
                                content: {
                                    SwiftUI.Image.compatSystemName("video")
                                        .font(.system(size: 11, weight: .bold))
                                        .padding(6)
                                },
                                popover: {
                                    PlayerView(url: Bundle.main.url(
                                        forResource: "Indicator-Near-Cursor-Demo-\($0 == .dark ? "Dark" : "Light")",
                                        withExtension: "mp4"
                                    )!)
                                        .frame(height: 118)

                                    Text("Enhanced Mode Required Tips".i18n())
                                        .font(.footnote)
                                        .opacity(0.6)
                                        .padding(.vertical, 10)
                                }
                            )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        VStack {
                            let needDisableAlwaysOnIndicator = !preferencesVM.preferences.isEnhancedModeEnabled || !preferencesVM.preferences.tryToDisplayIndicatorNearCursor

                            HStack {
                                Toggle("", isOn: $preferencesVM.preferences.isEnableAlwaysOnIndicator)
                                    .disabled(needDisableAlwaysOnIndicator)
                                    .toggleStyle(SwitchToggleStyle())
                                    .labelsHidden()

                                Text("isEnableAlwaysOnIndicator".i18n())

                                Spacer()

                                QuestionButton(
                                    content: {
                                        SwiftUI.Image.compatSystemName("video")
                                            .font(.system(size: 11, weight: .bold))
                                            .padding(6)
                                    },
                                    popover: {
                                        PlayerView(url: Bundle.main.url(
                                            forResource: "Always-On-Indicator-Demo-\($0 == .dark ? "Dark" : "Light")",
                                            withExtension: "mp4"
                                        )!)
                                            .frame(height: 118)

                                        Text("alwaysOnIndicatorTips".i18n())
                                            .font(.footnote)
                                            .padding(.vertical, 10)
                                            .opacity(0.6)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                }
            }
            .padding()
            .padding(.bottom)
        }
        .onAppear(perform: updatePreviewModeOnAppear)
        .background(NSColor.background1.color)
    }

    private var screenRecordingPermissionWarning: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image.compatSystemName("exclamationmark.triangle.fill")
                    .foregroundColor(.orange)

                Text("Screen Recording Required".i18n())
                    .fontWeight(.medium)
            }

            HStack(alignment: .center, spacing: 12) {
                Text("Window-based indicator positioning requires Screen Recording permission.".i18n())
                    .foregroundColor(.secondary)

                Spacer()

                Button("Open Screen Recording Settings".i18n()) {
                    PermissionsVM.checkScreenRecording(prompt: true)
                    permissionsVM.isScreenRecordingEnabled = PermissionsVM.checkScreenRecording(prompt: false)
                    NSWorkspace.shared.openScreenRecordingPreferences()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.bottom)
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
