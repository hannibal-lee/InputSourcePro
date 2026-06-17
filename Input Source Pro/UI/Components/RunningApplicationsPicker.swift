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
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 20)
            .contentShape(Rectangle())
        }
        .buttonStyle(RunningApplicationsPickerButtonStyle())
        .disabled(apps.isEmpty)
    }
}

private struct RunningApplicationsPickerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.primary)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(NSColor.controlColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(NSColor.separatorColor).opacity(0.5), lineWidth: 1)
            )
            .clipped()
    }
}
