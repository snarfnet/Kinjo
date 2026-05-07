import SwiftUI

extension Color {
    static let kinjoBackground = Color(hex: "#F4F1EA")
    static let kinjoInk = Color(hex: "#14213D")
    static let kinjoText = Color(hex: "#243036")
    static let kinjoSubtext = Color(hex: "#697278")
    static let kinjoCard = Color(hex: "#FFFDF8")
    static let kinjoCream = Color(hex: "#F8E9D0")
    static let kinjoGreen = Color(hex: "#2F7D5B")
    static let kinjoTeal = Color(hex: "#207C8C")
    static let kinjoGold = Color(hex: "#C58B2B")
    static let kinjoCoral = Color(hex: "#D85C4A")
    static let kinjoBlue = Color(hex: "#2C6FA3")
    static let kinjoSeparator = Color(hex: "#E1DED6")
    static let kinjoRed = Color.kinjoCoral

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

enum KinjoSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum KinjoRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 18
}

extension Font {
    static func kinjoTitle() -> Font { .system(size: 28, weight: .heavy, design: .rounded) }
    static func kinjoHeadline() -> Font { .system(size: 17, weight: .bold, design: .rounded) }
    static func kinjoBody() -> Font { .system(size: 15, weight: .regular, design: .rounded) }
    static func kinjoCaption() -> Font { .system(size: 12, weight: .medium, design: .rounded) }
}

struct KinjoCardModifier: ViewModifier {
    var padding: CGFloat = KinjoSpacing.md

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.kinjoCard)
            .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: KinjoRadius.lg, style: .continuous)
                    .stroke(Color.white.opacity(0.75), lineWidth: 1)
            )
            .shadow(color: Color.kinjoInk.opacity(0.08), radius: 16, x: 0, y: 10)
    }
}

extension View {
    func kinjoCard(padding: CGFloat = KinjoSpacing.md) -> some View {
        modifier(KinjoCardModifier(padding: padding))
    }
}

struct KinjoBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#F8F4EA"), Color(hex: "#E8F1EF"), Color(hex: "#F7E7DD")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(Color.kinjoGold.opacity(0.16))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -140, y: -280)
            Circle()
                .fill(Color.kinjoTeal.opacity(0.14))
                .frame(width: 320, height: 320)
                .blur(radius: 70)
                .offset(x: 150, y: 240)
        }
        .ignoresSafeArea()
    }
}

struct KinjoCardHeader: View {
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: KinjoSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(tint)
                .frame(width: 32, height: 32)
                .background(tint.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.kinjoHeadline())
                    .foregroundColor(.kinjoText)
                Text(subtitle)
                    .font(.kinjoCaption())
                    .foregroundColor(.kinjoSubtext)
            }
            Spacer()
        }
    }
}

struct KinjoArtworkCard: View {
    let imageName: String
    let title: String
    let caption: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 156)
                .clipped()

            LinearGradient(colors: [.clear, .black.opacity(0.72)], startPoint: .center, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(caption)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.86))
            }
            .padding(KinjoSpacing.md)
        }
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.lg, style: .continuous))
        .shadow(color: Color.kinjoInk.opacity(0.12), radius: 14, x: 0, y: 8)
    }
}

struct SkeletonView: View {
    @State private var animate = false

    var body: some View {
        RoundedRectangle(cornerRadius: KinjoRadius.sm, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color.kinjoSeparator, Color.white.opacity(0.6), Color.kinjoSeparator],
                    startPoint: animate ? .leading : .trailing,
                    endPoint: animate ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.3).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
    }
}

struct CardSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.sm) {
            SkeletonView().frame(height: 22).frame(maxWidth: 180)
            SkeletonView().frame(height: 14)
            SkeletonView().frame(height: 14).frame(maxWidth: 240)
            SkeletonView().frame(height: 90)
        }
        .kinjoCard()
        .padding(.horizontal, KinjoSpacing.md)
    }
}
