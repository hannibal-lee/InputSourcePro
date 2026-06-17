import SwiftUI

struct PromotionBadge: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Promotion".i18n())
            
            Spacer(minLength: 10)
            
            HStack {
                Spacer()

                Button(action: {
                    URL.website.open()
                }) {
                    HStack {
                        Image.compatSystemName("square.and.arrow.up.fill")
                            .foregroundColor(Color.blue)
                        Text("Share with friends".i18n())
                    }
                }

                
                Button(action: {
                    URL(string: "https://github.com/runjuu/InputSourcePro")?.open()
                }) {
                    HStack {
                        Image.compatSystemName("star.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                        Text("Star on GitHub".i18n())
                    }
                }
                
                Button(action: {
                    URL(string: "https://github.com/sponsors/runjuu")?.open()
                }) {
                    HStack {
                        Image.compatSystemName("heart.fill")
                            .foregroundColor(Color.pink)
                        Text("Sponsor".i18n())
                    }
                }
            }
        }
        .padding()
    }
}

// add support for Canvas Preview
struct PromotionBadge_Previews: PreviewProvider {
    static var previews: some View {
        PromotionBadge()
            .frame(width: 635, height: 95)
    }
}
