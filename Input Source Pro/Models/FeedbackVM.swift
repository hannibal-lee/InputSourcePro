import SwiftUI

final class FeedbackVM: ObservableObject {
    enum Status {
        case hided, editing, sending, sent
    }

    var isSent: Bool { status == .sent }

    var isSending: Bool { status == .sending }

    var isPresented: Bool { status != .hided }

    @Published private(set) var status = Status.hided

    @Published var message = ""

    @Published var email = ""

    func show() {
        if status == .hided {
            status = .editing
        }
    }

    func hide() {
        if status != .sending {
            status = .hided
        }
    }

    func sendFeedback() {
        withAnimation {
            status = .sending
        }

        message = ""
        email = ""

        withAnimation {
            status = .sent
        }
    }
}
