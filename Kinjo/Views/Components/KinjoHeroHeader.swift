import SwiftUI

struct KinjoHeroHeader: View {
    let cityName: String

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<11: return "おはようございます"
        case 11..<17: return "今日の街を見てみましょう"
        case 17..<22: return "帰り道も安心に"
        default: return "静かな夜の見守り"
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("kinjo-hero-town")
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.04), .black.opacity(0.78)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: KinjoSpacing.sm) {
                HStack(spacing: KinjoSpacing.xs) {
                    Image(systemName: "location.fill")
                    Text(cityName.isEmpty ? "現在地" : cityName)
                }
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial.opacity(0.35))
                .clipShape(Capsule())

                Text("近所")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

                Text(greeting)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.92))

                Text("天気、交通、防災、街のニュースを一枚のボードにまとめます。")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.84))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(KinjoSpacing.lg)
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: Color.kinjoInk.opacity(0.18), radius: 18, x: 0, y: 12)
    }
}

#Preview {
    KinjoHeroHeader(cityName: "東京")
        .padding()
        .background(KinjoBackground())
}
