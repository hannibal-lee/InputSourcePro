import SwiftUI

struct AccessibilityPermissionRequestView: View {
    @EnvironmentObject var permissionsVM: PermissionsVM
    @EnvironmentObject var preferencesVM: PreferencesVM

    @Binding var isPresented: Bool

    @State var isDisableTips: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            Text(.init("Enhanced Mode Permission Description".i18n()))
                .lineSpacing(4)

            HStack {
                Button(action: URL.howToEnableAccessbility.open) {
                    SwiftUI.Image.compatSystemName("questionmark")
                }
                .font(Font.system(size: 10).weight(Font.Weight.bold))
                .frame(width: 18, height: 18)
                .clipShape(RoundedRectangle(cornerRadius: 99))
                .disabled(isDisableTips)

                Spacer()

                Button("Open Accessibility Preferences") {
                    NSWorkspace.shared.openAccessibilityPreferences()
                }

                Button("Cancel", action: cancel)
            }
            .padding(.top)
        }
        .padding()
        .lineLimit(nil)
        .frame(width: 400)
        .onChangeCompat(of: permissionsVM.isAccessibilityEnabled, perform: whenAccessibilityEnabled)
        .onAppear {
            DispatchQueue.main.async {
                isDisableTips = false
            }
        }
    }

    func cancel() {
        isPresented = false
    }

    func whenAccessibilityEnabled(_ isAccessibilityEnabled: Bool) {
        if isAccessibilityEnabled {
            isPresented = false
            preferencesVM.update {
                $0.isEnhancedModeEnabled = true
            }
        }
    }
}
