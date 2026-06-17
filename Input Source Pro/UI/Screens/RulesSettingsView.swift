import SwiftUI

struct RulesSettingsView: View {
    @State var selectedApp = Set<AppRule>()

    @EnvironmentObject var preferencesVM: PreferencesVM

    private let applicationListWidth: CGFloat = 245
    private let toolbarButtonWidth: CGFloat = 38
    private let toolbarSpacing: CGFloat = 5
    private let toolbarPadding: CGFloat = 10

    private var runningAppsButtonWidth: CGFloat {
        applicationListWidth - (toolbarPadding * 2) - (toolbarButtonWidth * 2) - (toolbarSpacing * 2)
    }

    var items: [PickerItem] {
        [PickerItem.empty]
            + InputSource.sources.map { PickerItem(id: $0.id, title: $0.name, toolTip: $0.id) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    ApplicationPicker(selectedApp: $selectedApp)
                        .frame(width: applicationListWidth, alignment: .topLeading)
                        .clipped()
                        .border(width: 1, edges: [.bottom], color: Color(NSColor.gridColor))

                    HStack(spacing: toolbarSpacing) {
                        Button(action: selectApp) {
                            SwiftUI.Image.compatSystemName("plus")
                        }
                        .frame(width: toolbarButtonWidth)

                        Button(action: removeApp) {
                            SwiftUI.Image.compatSystemName("minus")
                        }
                        .disabled(selectedApp.isEmpty)
                        .frame(width: toolbarButtonWidth)

                        RunningApplicationsPicker(onSelect: selectRunningApp)
                            .frame(width: runningAppsButtonWidth)
                    }
                    .padding(toolbarPadding)
                    .frame(width: applicationListWidth, alignment: .leading)
                    .clipped()
                }
                .frame(width: applicationListWidth, alignment: .topLeading)
                .clipped()
                .border(width: 1, edges: [.trailing], color: Color(NSColor.gridColor))

                ApplicationDetail(selectedApp: $selectedApp)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    func selectApp() {
        let panel = NSOpenPanel()

        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.setCompatAllowedFileTypes(["app"])

        if let applicationPath = NSSearchPathForDirectoriesInDomains(
            .applicationDirectory,
            .localDomainMask,
            true
        ).first {
            panel.directoryURL = URL(fileURLWithPath: applicationPath, isDirectory: true)
        }

        if panel.runModal() == .OK {
            selectedApp = Set(panel.urls.map {
                preferencesVM.addAppCustomization($0, bundleId: $0.bundleId())
            })
        }
    }

    func removeApp() {
        for app in selectedApp {
            preferencesVM.removeAppCustomization(app)
        }
        selectedApp.removeAll()
    }

    func selectRunningApp(_ app: NSRunningApplication) {
        if let appRule = preferencesVM.addAppCustomization(app) {
            selectedApp = Set([appRule])
        }
    }
}
