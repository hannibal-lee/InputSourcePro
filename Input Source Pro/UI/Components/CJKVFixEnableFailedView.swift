import SwiftUI

struct CJKVFixEnableFailedView: View {
    @Binding var isPresented: Bool

    @State var isOpened = false

    var body: some View {
        VStack(spacing: 0) {
            Text("CJKV Fix Shortcut Method Failed Desc".i18n())

            Image("Enabled CJKV Fix Shortcut Img".i18n())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: Color.black.opacity(0.26), radius: 8)
                .padding(20)

            HStack {
                Spacer()

                if isOpened {
                    Button("Close", action: { isPresented = false })
                } else {
                    Button("Cancel", action: { isPresented = false })

                    Button("Open Keyboard Settings", action: {
                        NSWorkspace.shared.openKeyboardPreferences()
                        isOpened = true
                    })
                }
            }
        }
        .padding()
        .frame(width: 480)
    }
}
