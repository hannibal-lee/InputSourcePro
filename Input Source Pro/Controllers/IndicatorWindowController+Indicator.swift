import AppKit

extension IndicatorWindowController {
    func getAppSize() -> CGSize? {
        return indicatorVC.fittingSize
    }

    func updateIndicator(event _: IndicatorVM.ActivateEvent, inputSource: InputSource) {
        let preferences = preferencesVM.preferences

        indicatorVC.prepare(config: IndicatorViewConfig(
            inputSource: inputSource,
            kind: preferences.indicatorKind,
            size: preferences.indicatorSize ?? .medium,
            bgColor: preferencesVM.getBgNSColor(inputSource),
            textColor: preferencesVM.getTextNSColor(inputSource)
        ))

        if isActive {
            indicatorVC.refresh()
            resizeIndicatorWindow()
        }
    }

    func moveIndicator(position: PreferencesVM.IndicatorPositionInfo) {
        indicatorVC.refresh()
        resizeIndicatorWindow()
        moveTo(point: position.point)
    }

    private func resizeIndicatorWindow() {
        guard let size = getAppSize(),
              size.width > 0,
              size.height > 0
        else { return }

        window?.setContentSize(size)
        indicatorVC.view.frame = CGRect(origin: .zero, size: size)
        indicatorVC.view.layoutSubtreeIfNeeded()
    }
}
