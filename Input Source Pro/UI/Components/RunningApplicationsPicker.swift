import SwiftUI

struct RunningApplicationsPicker: View {
    @EnvironmentObject var preferencesVM: PreferencesVM

    let appIconSize: CGFloat = 18

    let onSelect: (NSRunningApplication) -> Void

    init(onSelect: @escaping (NSRunningApplication) -> Void) {
        self.onSelect = onSelect
    }

    private var apps: [NSRunningApplication] {
        preferencesVM.filterApps(NSWorkspace.shared.runningApplications)
    }

    var body: some View {
        Button(action: {
            if let app = apps.first {
                onSelect(app)
            }
        }) {
            HStack(spacing: 6) {
                Image.compatSystemName("plus")
                Text("Add Running Apps".i18n())
            }
        }
        .disabled(apps.isEmpty)
    }
}
