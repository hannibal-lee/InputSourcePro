import SwiftUI

struct ApplicationPicker: View {
    @Binding var selectedApp: Set<AppRule>

    @EnvironmentObject var preferencesVM: PreferencesVM

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "bundleName", ascending: true)])
    var appCustomizations: FetchedResults<AppRule>

    let appIconSize: CGFloat = 18
    let keyboardIconSize: CGFloat = 16
    private let rowHeight: CGFloat = 32

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(appCustomizations, id: \.self) { app in
                        ApplicationPickerRow(
                            app: app,
                            isSelected: selectedApp.contains(app),
                            appIconSize: appIconSize,
                            keyboardIconSize: keyboardIconSize
                        )
                        .frame(width: geometry.size.width, height: rowHeight, alignment: .leading)
                        .contentShape(Rectangle())
                        .background(selectedApp.contains(app) ? Color.accentColor.opacity(0.28) : Color.clear)
                        .onTapGesture {
                            selectedApp = [app]
                        }
                    }
                }
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .onAppear {
            if selectedApp.isEmpty, let app = appCustomizations.first {
                selectedApp.update(with: app)
            }
        }
    }
}

private struct ApplicationPickerRow: View {
    @ObservedObject var app: AppRule

    @EnvironmentObject var preferencesVM: PreferencesVM

    let isSelected: Bool
    let appIconSize: CGFloat
    let keyboardIconSize: CGFloat

    private var bundleTitle: String {
        app.bundleName ?? "(unknown)"
    }

    private var helpText: String {
        app.bundleName ?? app.url?.path ?? "(unknown)"
    }

    private var shouldShowEnhancedModePrompt: Bool {
        preferencesVM.needDisplayEnhancedModePrompt(bundleIdentifier: app.bundleId)
    }

    private var doNotRestoreColor: Color {
        isSelected ? Color.primary : Color.green
    }

    private var doRestoreColor: Color {
        isSelected ? Color.primary : Color.blue
    }

    var body: some View {
        HStack(spacing: 8) {
            if let image = app.image {
                SwiftUI.Image(nsImage: image)
                    .resizable()
                    .frame(width: appIconSize, height: appIconSize)
            } else {
                SwiftUI.Image.compatSystemName("app.dashed")
                    .resizable()
                    .frame(width: appIconSize, height: appIconSize)
            }

            Text(bundleTitle)
                .lineLimit(1)

            Spacer()

            if app.hideIndicator {
                RuleSettingIcon(systemName: "eye.slash.circle.fill", color: Color.gray)
                    .opacity(0.7)
            }

            if app.forceEnglishPunctuation {
                RuleSettingIcon(text: "Aa", color: Color.orange)
                    .opacity(0.7)
            }

            if shouldShowEnhancedModePrompt {
                RuleSettingIcon(
                    systemName: "exclamationmark.triangle.fill",
                    color: Color(red: 1.0, green: 0.84, blue: 0.0)
                )
            }

            if preferencesVM.preferences.isRestorePreviouslyUsedInputSource {
                if app.doNotRestoreKeyboard {
                    RuleSettingIcon(systemName: "d.circle.fill", color: doNotRestoreColor)
                        .opacity(isSelected ? 0.7 : 1.0)
                }
            } else {
                if app.doRestoreKeyboard {
                    RuleSettingIcon(systemName: "arrow.uturn.left.circle.fill", color: doRestoreColor)
                        .opacity(isSelected ? 0.7 : 1.0)
                }
            }

            if let functionKeyMode = app.functionKeyMode {
                let systemName = functionKeyMode == .functionKeys ? "keyboard" : "sun.max"
                RuleSettingIcon(systemName: systemName)
                    .opacity(0.7)
            }

            if let icon = app.forcedKeyboard?.icon {
                SwiftUI.Image(nsImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: keyboardIconSize, height: keyboardIconSize)
                    .opacity(0.7)
            }
        }
        .padding(.horizontal, 10)
        .clipped()
    }
}
