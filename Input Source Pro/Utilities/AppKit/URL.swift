import AppKit

extension URL {
    static let newtab = URL(string: "isp://newtab")!

    func open() {
        NSWorkspace.shared.open(self)
    }

    func bundleId() -> String {
        Bundle(url: self)?.bundleIdentifier ?? dataRepresentation.md5()
    }

    func removeFragment() -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)

        components?.fragment = nil

        return components?.url ?? self
    }
}

extension URL {
    static let forkRepository = URL(
        string: "https://github.com/hannibal-lee/InputSourcePro"
    )!

    static let forkReleases = URL(
        string: "https://github.com/hannibal-lee/InputSourcePro/releases"
    )!

    static let forkIssues = URL(
        string: "https://github.com/hannibal-lee/InputSourcePro/issues"
    )!

    static let upstreamRepository = URL(
        string: "https://github.com/runjuu/InputSourcePro"
    )!

    static let howToEnableAccessbility = URL(
        string: "https://inputsource.pro/help/enable-spotlight-like-apps-support"
    )!

    static let howToEnableBrowserRule = URL(
        string: "https://inputsource.pro/help/enable-browser-rule"
    )!
}
