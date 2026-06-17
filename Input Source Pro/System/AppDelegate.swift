import Cocoa
import Combine
import SwiftUI
import LaunchAtLogin

class AppDelegate: NSObject, NSApplicationDelegate {
    var navigationVM: NavigationVM!
    var indicatorVM: IndicatorVM!
    var preferencesVM: PreferencesVM!
    var permissionsVM: PermissionsVM!
    var applicationVM: ApplicationVM!
    var inputSourceVM: InputSourceVM!
    var feedbackVM: FeedbackVM!
    var indicatorWindowController: IndicatorWindowController!
    var statusItemController: StatusItemController!
    var previousInstalledBuildVersionAtLaunch = 0

    func applicationDidFinishLaunching(_: Notification) {
        previousInstalledBuildVersionAtLaunch = UserDefaults.standard.integer(forKey: "prevInstalledBuildVersion")

        feedbackVM = FeedbackVM()
        navigationVM = NavigationVM()
        permissionsVM = PermissionsVM()
        preferencesVM = PreferencesVM(permissionsVM: permissionsVM)
        applicationVM = ApplicationVM(preferencesVM: preferencesVM)
        inputSourceVM = InputSourceVM(preferencesVM: preferencesVM)
        indicatorVM = IndicatorVM(permissionsVM: permissionsVM, preferencesVM: preferencesVM, applicationVM: applicationVM, inputSourceVM: inputSourceVM)

        indicatorWindowController = IndicatorWindowController(
            permissionsVM: permissionsVM,
            preferencesVM: preferencesVM,
            indicatorVM: indicatorVM,
            applicationVM: applicationVM,
            inputSourceVM: inputSourceVM
        )

        statusItemController = StatusItemController(
            navigationVM: navigationVM,
            permissionsVM: permissionsVM,
            preferencesVM: preferencesVM,
            applicationVM: applicationVM,
            indicatorVM: indicatorVM,
            feedbackVM: feedbackVM,
            inputSourceVM: inputSourceVM
        )
        
        LaunchAtLogin.migrateIfNeeded()
        openPreferencesAtFirstLaunch()
        sendLaunchPing()
        updateInstallVersionInfo()
    }

    func applicationDidBecomeActive(_: Notification) {
        guard !InputSourceSwitcher.isHandlingTemporaryInputWindowActivation else { return }

        DispatchQueue.main.async {
            self.statusItemController.openPreferences()
        }
    }

    func openPreferencesAtFirstLaunch() {
        if previousInstalledBuildVersionAtLaunch != preferencesVM.preferences.buildVersion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.statusItemController.openPreferences()
            }
        }
    }

    func updateInstallVersionInfo() {
        preferencesVM.preferences.prevInstalledBuildVersion = preferencesVM.preferences.buildVersion
    }
    
    func sendLaunchPing() {
    }
}
