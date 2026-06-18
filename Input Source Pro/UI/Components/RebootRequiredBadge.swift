import SwiftUI

struct RebootRequiredBadge: View {
    let isRequired: Bool
    
    var body: some View {
        Text("System Reboot Required".i18n())
            .font(.system(size: 10))
            .padding(.horizontal, 4)
            .padding(.vertical, 3)
            .background(Color.gray)
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .opacity(isRequired ? 1 : 0)
            .animation(.easeInOut, value: isRequired)
    }
}
