import SwiftUI

struct EnhancedModeRequiredBadge: View {
    @EnvironmentObject var preferencesVM: PreferencesVM

    var body: some View {
        Text("Enhanced Mode Required".i18n())
            .font(.system(size: 10))
            .padding(.horizontal, 4)
            .padding(.vertical, 3)
            .background(Color.yellow)
            .foregroundColor(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .opacity(preferencesVM.preferences.isEnhancedModeEnabled ? 0 : 1)
            .animation(.easeInOut, value: preferencesVM.preferences.isEnhancedModeEnabled)
    }
}
