import AppKit

extension NSImage {
    static var triangle: NSImage {
        if let image = NSImage(named: "Triangle") {
            return image
        }

        let image = NSImage(size: NSSize(width: 30, height: 30))
        image.lockFocus()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 0, y: 0))
        path.line(to: NSPoint(x: 30, y: 15))
        path.line(to: NSPoint(x: 0, y: 30))
        path.close()
        NSColor.labelColor.setFill()
        path.fill()
        image.unlockFocus()
        image.isTemplate = true
        return image
    }

    func markTemplateIfGrayScaleOrPdf(url: URL? = nil) -> NSImage {
        let image = copy() as! NSImage

        if url?.pathExtension == "pdf" || isGrayScale() {
            image.isTemplate = true
        }

        return image
    }

    func isGrayScale() -> Bool {
        guard let imageRef = cgImage(),
              let colorSpace = imageRef.colorSpace
        else { return false }

        if colorSpace.model == .monochrome {
            return true
        }

        guard let imageData = imageRef.dataProvider?.data,
              let rawData = CFDataGetBytePtr(imageData)
        else { return false }

        var byteIndex = 0

        for _ in 0 ..< imageRef.width * imageRef.height {
            let r = rawData[byteIndex]
            let g = rawData[byteIndex + 1]
            let b = rawData[byteIndex + 2]

            if r == g && g == b {
                byteIndex += 4
            } else {
                return false
            }
        }

        return true
    }

    func cgImage() -> CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
