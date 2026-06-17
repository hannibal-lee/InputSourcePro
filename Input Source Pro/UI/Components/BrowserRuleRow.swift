import SwiftUI

struct BrowserRuleRow: View {
    @State var showModal = false
    
    var isSelected: Bool = false
    
    @ObservedObject var rule: BrowserRule

    @EnvironmentObject var preferencesVM: PreferencesVM

    let imgSize: CGFloat = 16

    var body: some View {
        HStack {
            Text(rule.value ?? "")

            Spacer()

            if rule.hideIndicator == true {
                Image.compatSystemName("eye.slash.circle.fill")
                    .opacity(0.7)
                    .frame(width: imgSize, height: imgSize)
            }

            if let keyboardRestoreStrategy = rule.keyboardRestoreStrategy {
                let symbolName = keyboardRestoreStrategy.systemImageName
                let color: Color = {
                    switch symbolName {
                    case "d.circle.fill", "d.square.fill":
                        return isSelected ? Color.primary.opacity(0.7) : Color.green
                    case "arrow.uturn.left.circle.fill":
                        return isSelected ? Color.primary.opacity(0.7) : Color.blue
                    default:
                        return Color.primary
                    }
                }()
                Image.compatSystemName(symbolName)
                    .foregroundColor(color)
                    .frame(width: imgSize, height: imgSize)
            }

            if let forcedKeyboard = rule.forcedKeyboard {
                SwiftUI.Image(nsImage: forcedKeyboard.icon ?? NSImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: imgSize, height: imgSize)
                    .opacity(0.7)
            }

            Text(rule.type.name)
                .font(.footnote)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            Button("Edit") {
                showModal = true
            }
        }
        .sheet(isPresented: $showModal, content: {
            BrowserRuleEditView(isPresented: $showModal, rule: rule)
                .environmentObject(preferencesVM)
        })
    }
}
