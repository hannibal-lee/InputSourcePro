import AppKit
import Combine
import CoreGraphics
import Darwin
import IOKit

private enum ScreenCaptureAccess {
    private typealias AccessFunction = @convention(c) () -> Bool

    private static let requestAccess = loadFunction(named: "CGRequestScreenCaptureAccess")
    private static let preflightAccess = loadFunction(named: "CGPreflightScreenCaptureAccess")

    static func check(prompt: Bool) -> Bool {
        if prompt, let requestAccess = requestAccess {
            return requestAccess()
        }

        if let preflightAccess = preflightAccess {
            return preflightAccess()
        }

        return legacyCheck()
    }

    private static func loadFunction(named name: String) -> AccessFunction? {
        guard
            let handle = dlopen("/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics", RTLD_LAZY),
            let symbol = dlsym(handle, name)
        else { return nil }

        return unsafeBitCast(symbol, to: AccessFunction.self)
    }

    private static func legacyCheck() -> Bool {
        guard let windows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]]
        else { return false }

        return windows.contains { window in
            guard
                let ownerPID = window["kCGWindowOwnerPID"] as? pid_t,
                ownerPID != getpid(),
                let layer = window["kCGWindowLayer"] as? Int,
                layer == 0
            else { return false }

            return window["kCGWindowName"] != nil
        }
    }
}

final class PermissionsVM: ObservableObject {
    @discardableResult
    static func checkAccessibility(prompt: Bool) -> Bool {
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        return AXIsProcessTrustedWithOptions([checkOptPrompt: prompt] as CFDictionary?)
    }

    @discardableResult
    static func checkInputMonitoring(prompt: Bool) -> Bool {
        if prompt {
            return IOHIDRequestAccess(kIOHIDRequestTypeListenEvent)
        } else {
            let access = IOHIDCheckAccess(kIOHIDRequestTypeListenEvent)
            return access == kIOHIDAccessTypeGranted
        }
    }

    @discardableResult
    static func checkScreenRecording(prompt: Bool) -> Bool {
        return ScreenCaptureAccess.check(prompt: prompt)
    }

    @Published var isAccessibilityEnabled = PermissionsVM.checkAccessibility(prompt: false)
    @Published var isInputMonitoringEnabled = PermissionsVM.checkInputMonitoring(prompt: false)
    @Published var isScreenRecordingEnabled = PermissionsVM.checkScreenRecording(prompt: false)

    private var cancelBag = CancelBag()

    init() {
        watchAccessibilityChange()
        watchInputMonitoringChange()
        watchScreenRecordingChange()
    }

    private func watchAccessibilityChange() {
        guard !isAccessibilityEnabled else { return }

        Timer
            .interval(seconds: 1)
            .map { _ in Self.checkAccessibility(prompt: false) }
            .filter { $0 }
            .first()
            .sink { [weak self] in self?.isAccessibilityEnabled = $0 }
            .store(in: cancelBag)
    }

    private func watchInputMonitoringChange() {
        guard !isInputMonitoringEnabled else { return }

        Timer
            .interval(seconds: 1)
            .map { _ in Self.checkInputMonitoring(prompt: false) }
            .filter { $0 }
            .first()
            .sink { [weak self] in self?.isInputMonitoringEnabled = $0 }
            .store(in: cancelBag)
    }

    private func watchScreenRecordingChange() {
        guard !isScreenRecordingEnabled else { return }

        Timer
            .interval(seconds: 1)
            .map { _ in Self.checkScreenRecording(prompt: false) }
            .filter { $0 }
            .first()
            .sink { [weak self] in self?.isScreenRecordingEnabled = $0 }
            .store(in: cancelBag)
    }
}
