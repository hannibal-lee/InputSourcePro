import SwiftUI

struct FeedbackButton: View {
    var body: some View {
        Button(
            action: { URL.forkIssues.open() },
            label: {
                HStack {
                    Text("Report Issue".i18n() + "...")
                    Spacer()
                }
            }
        )
        .buttonStyle(SectionButtonStyle())
    }
}
