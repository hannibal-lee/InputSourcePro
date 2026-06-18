import AppKit
import SwiftUI

struct RunningApplicationsPicker: NSViewRepresentable {
    final class Coordinator: NSObject {
        private let parent: RunningApplicationsPicker
        private var apps: [NSRunningApplication] = []

        init(parent: RunningApplicationsPicker) {
            self.parent = parent
        }

        func updateApps(_ apps: [NSRunningApplication]) {
            self.apps = apps
        }

        @objc func selectApp(_ sender: NSPopUpButton) {
            let index = sender.indexOfSelectedItem - 1

            guard apps.indices.contains(index) else {
                sender.selectItem(at: 0)
                return
            }

            parent.onSelect(apps[index])
            sender.selectItem(at: 0)
        }
    }

    @EnvironmentObject var preferencesVM: PreferencesVM

    let onSelect: (NSRunningApplication) -> Void

    init(onSelect: @escaping (NSRunningApplication) -> Void) {
        self.onSelect = onSelect
    }

    private var apps: [NSRunningApplication] {
        preferencesVM.filterApps(NSWorkspace.shared.runningApplications)
            .sorted {
                ($0.localizedName ?? $0.bundleIdentifier ?? "") < ($1.localizedName ?? $1.bundleIdentifier ?? "")
            }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> NSPopUpButton {
        let button = NSPopUpButton(frame: .zero, pullsDown: true)

        button.autoenablesItems = false
        button.target = context.coordinator
        button.action = #selector(Coordinator.selectApp(_:))
        button.bezelStyle = .rounded

        return button
    }

    func updateNSView(_ button: NSPopUpButton, context: Context) {
        let apps = self.apps

        context.coordinator.updateApps(apps)

        button.removeAllItems()
        button.addItem(withTitle: "Add Running Apps".i18n())

        guard !apps.isEmpty else {
            button.isEnabled = false
            return
        }

        button.isEnabled = true

        for app in apps {
            let item = NSMenuItem(title: app.localizedName ?? app.bundleIdentifier ?? "(unknown)", action: nil, keyEquivalent: "")

            item.image = app.icon
            item.toolTip = app.bundleIdentifier
            button.menu?.addItem(item)
        }

        button.selectItem(at: 0)
    }
}
