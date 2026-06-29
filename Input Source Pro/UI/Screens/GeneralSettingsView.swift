import SwiftUI
import UniformTypeIdentifiers

struct GeneralSettingsView: View {
    @EnvironmentObject var preferencesVM: PreferencesVM
    @EnvironmentObject var permissionsVM: PermissionsVM
    @EnvironmentObject var indicatorVM: IndicatorVM

    @State var isDetectSpotlightLikeApp = false

    var items: [PickerItem] {
        [PickerItem.empty]
            + InputSource.sources.map {
                PickerItem(id: $0.persistentIdentifier, title: $0.name, toolTip: $0.persistentIdentifier)
            }
    }

    var body: some View {
        let keyboardRestoreStrategyBinding = Binding(
            get: { preferencesVM.preferences.isRestorePreviouslyUsedInputSource ?
                KeyboardRestoreStrategy.RestorePreviouslyUsedOne :
                KeyboardRestoreStrategy.UseDefaultKeyboardInstead
            },
            set: { newValue in
                preferencesVM.update {
                    switch newValue {
                    case .RestorePreviouslyUsedOne:
                        $0.isRestorePreviouslyUsedInputSource = true
                    case .UseDefaultKeyboardInstead:
                        $0.isRestorePreviouslyUsedInputSource = false
                    }
                }
            }
        )

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                SettingsSection(title: "Default Keyboard") {
                    HStack {
                        Text("For All Apps and Websites".i18n())

                        PopUpButtonPicker<PickerItem?>(
                            items: items,
                            isItemSelected: {
                                $0?.id == (preferencesVM.systemWideDefaultKeyboard?.persistentIdentifier ?? PickerItem.empty.id)
                            },
                            getTitle: { $0?.title ?? "" },
                            getToolTip: { $0?.toolTip },
                            onSelect: handleSystemWideDefaultKeyboardSelect
                        )
                    }
                    .padding()
                    .border(width: 1, edges: [.bottom], color: NSColor.border2.color)
                }

                SettingsSection(title: "Keyboard Restore Strategy") {
                    VStack(alignment: .leading) {
                        Text("When Switching Back to the App or Website".i18n() + ":")

                        Picker("Keyboard Restore Strategy", selection: keyboardRestoreStrategyBinding) {
                            ForEach(KeyboardRestoreStrategy.allCases) { item in
                                Text(item.name).tag(item)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .flexibleButtonSizing()
                    }
                    .padding()
                }
                
                SettingsSection(title: "Default Function Keys") {
                    VStack(alignment: .leading) {
                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isFunctionKeysEnabled)

                            Text("Function Keys Description".i18n())

                            Spacer()
                        }
                    }
                    .padding()
                }

                Group {
                    SettingsSection(title: "Indicator Triggers") {
                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isActiveWhenLongpressLeftMouse)

                            Text("isActiveWhenLongpressLeftMouse".i18n())

                            Spacer()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isActiveWhenSwitchInputSource)

                            Text("isActiveWhenSwitchInputSource".i18n())

                            Spacer()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isActiveWhenSwitchApp)

                            Text("isActiveWhenSwitchApp".i18n())

                            Spacer()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isActiveWhenFocusedElementChanges)
                                .disabled(!preferencesVM.preferences.isEnhancedModeEnabled)

                            Text("isActiveWhenFocusedElementChanges".i18n())

                            Spacer()

                            EnhancedModeRequiredBadge()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)
                    }

                    SettingsSection(title: "") {
                        HStack {
                            Toggle("",
                                   isOn: $preferencesVM.preferences.isHideWhenSwitchAppWithForceKeyboard)
                                .disabled(!(
                                    preferencesVM.preferences.isActiveWhenSwitchApp ||
                                        preferencesVM.preferences.isActiveWhenSwitchInputSource ||
                                        preferencesVM.preferences.isActiveWhenFocusedElementChanges
                                ))

                            Text("isHideWhenSwitchAppWithForceKeyboard")

                            Spacer()
                        }
                        .padding()
                    }
                }

                Group {
                    SettingsSection(title: "System") {
                        EnhancedModeToggle()
                            .border(width: 1, edges: [.bottom], color: NSColor.border2.color)
                        
                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isLaunchAtLogin)
                            Text("Launch at Login".i18n())
                            Spacer()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        HStack {
                            Toggle("", isOn: $preferencesVM.preferences.isShowIconInMenuBar)
                            Text("Display Icon in Menu Bar".i18n())
                            Spacer()
                        }
                        .padding()
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)
                    }

                    SettingsSection(title: "") {
                        HStack {
                            Text("Version".i18n())

                            Spacer()

                            Text(" \(preferencesVM.versionStr) (\(preferencesVM.buildStr))")
                                .foregroundColor(Color.primary.opacity(0.5))
                        }
                        .padding()
                    }
                }

                SettingsSection(title: "Settings Backup") {
                    Button(action: exportSettings) {
                        HStack {
                            Text("Export Settings".i18n() + "...")

                            Spacer()
                        }
                    }
                    .buttonStyle(SectionButtonStyle())
                    .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                    Button(action: importSettings) {
                        HStack {
                            Text("Import Settings".i18n() + "...")

                            Spacer()
                        }
                    }
                    .buttonStyle(SectionButtonStyle())
                }

                Group {
                    SettingsSection(title: "Fork Project", tips: Text("Right click each section to copy link").font(.subheadline).opacity(0.5)) {
                        Button(action: { URL.forkRepository.open() }, label: {
                            HStack {
                                Text("Fork Repository".i18n())
                                    .foregroundColor(Color.primary)

                                Spacer()

                                Text(URL.forkRepository.absoluteString)
                            }
                        })
                        .buttonStyle(SectionButtonStyle())
                        .contextMenu {
                            Button("Copy".i18n()) {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(URL.forkRepository.absoluteString, forType: .string)
                            }
                        }
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        Button(action: { URL.forkReleases.open() }, label: {
                            HStack {
                                Text("Fork Releases".i18n())
                                    .foregroundColor(Color.primary)

                                Spacer()

                                Text(URL.forkReleases.absoluteString)
                            }
                        })
                        .buttonStyle(SectionButtonStyle())
                        .contextMenu {
                            Button("Copy".i18n()) {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(URL.forkReleases.absoluteString, forType: .string)
                            }
                        }
                        .border(width: 1, edges: [.bottom], color: NSColor.border2.color)

                        Button(action: { URL.upstreamRepository.open() }, label: {
                            HStack {
                                Text("Upstream Project".i18n())
                                    .foregroundColor(Color.primary)

                                Spacer()

                                Text(URL.upstreamRepository.absoluteString)
                            }
                        })
                        .buttonStyle(SectionButtonStyle())
                        .contextMenu {
                            Button("Copy".i18n()) {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(URL.upstreamRepository.absoluteString, forType: .string)
                            }
                        }
                    }
                }
                
                SettingsSection(title: "Privacy") {
                    HStack {
                        Text("Privacy Content".i18n())
                            .multilineTextAlignment(.leading)
                            .padding()
                            .opacity(0.8)

                        Spacer(minLength: 0)
                    }
                }

                HStack {
                    Spacer()
                    Text("Input Source Pro 10.15 fork for macOS 10.15 Catalina")
                    Spacer()
                }
                .font(.footnote)
                .opacity(0.5)
            }
            .padding()
        }
        .labelsHidden()
        .toggleStyle(SwitchToggleStyle())
        .background(NSColor.background1.color)
        .onAppear(perform: disableIsDetectSpotlightLikeAppIfNeed)
    }

    func disableIsDetectSpotlightLikeAppIfNeed() {
        if !permissionsVM.isAccessibilityEnabled && preferencesVM.preferences.isEnhancedModeEnabled {
            preferencesVM.update {
                $0.isEnhancedModeEnabled = false
            }
        }
    }

    func handleSystemWideDefaultKeyboardSelect(_ index: Int) {
        let defaultKeyboard = items[index]

        preferencesVM.update {
            $0.systemWideDefaultKeyboardId = defaultKeyboard.id
        }
    }

    func exportSettings() {
        let panel = NSSavePanel()
        panel.title = "Export Settings".i18n()
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.nameFieldStringValue = "Input Source Pro 10.15 Settings"
        panel.setCompatAllowedFileTypes(["json"])

        guard panel.runModal() == .OK,
              var url = panel.url
        else { return }

        if url.pathExtension.isEmpty {
            url.appendPathExtension("json")
        }

        do {
            let data = try preferencesVM.exportSettingsBackupData()
            try data.write(to: url, options: .atomic)
            showSettingsBackupAlert(
                title: "Settings Exported".i18n(),
                message: "Settings Exported Message".i18n(),
                style: .informational
            )
        } catch {
            showSettingsBackupAlert(
                title: "Export Settings Failed".i18n(),
                message: error.localizedDescription,
                style: .critical
            )
        }
    }

    func importSettings() {
        let panel = NSOpenPanel()
        panel.title = "Import Settings".i18n()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.setCompatAllowedFileTypes(["json"])

        guard panel.runModal() == .OK,
              let url = panel.url
        else { return }

        do {
            let backup = try preferencesVM.readSettingsBackup(from: url)

            guard confirmSettingsImport() else { return }

            try preferencesVM.importSettingsBackup(backup)
            indicatorVM.refreshShortcut()
            showSettingsBackupAlert(
                title: "Settings Imported".i18n(),
                message: "Settings Imported Message".i18n(),
                style: .informational
            )
        } catch {
            showSettingsBackupAlert(
                title: "Import Settings Failed".i18n(),
                message: error.localizedDescription,
                style: .critical
            )
        }
    }

    func confirmSettingsImport() -> Bool {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Replace Current Settings?".i18n()
        alert.informativeText = "Import Settings Confirmation Message".i18n()
        alert.addButton(withTitle: "Import Settings".i18n())
        alert.addButton(withTitle: "Cancel".i18n())
        return alert.runModal() == .alertFirstButtonReturn
    }

    func showSettingsBackupAlert(title: String, message: String, style: NSAlert.Style) {
        let alert = NSAlert()
        alert.alertStyle = style
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
