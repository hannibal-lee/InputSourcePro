import SwiftUI

struct QuestionMark<Content: View>: View {
    @State var isPresented: Bool = false

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        Button(action: { isPresented.toggle() }) {
            SwiftUI.Image.compatSystemName("questionmark")
        }
        .font(Font.system(size: 10).weight(Font.Weight.bold))
        .frame(width: 18, height: 18)
        .clipShape(RoundedRectangle(cornerRadius: 99))
        .popover(isPresented: $isPresented, arrowEdge: .top) {
            content
        }
    }
}
