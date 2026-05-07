import SwiftUI

struct EarthquakeCard: View {
    let items: [EarthquakeItem]

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "地震情報", subtitle: "近い場所から新しい順に確認", icon: "waveform.path.ecg", tint: .kinjoCoral)

            Image("kinjo-safety-map")
                .resizable()
                .scaledToFill()
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.lg, style: .continuous))

            if items.isEmpty {
                Text("現在、表示できる地震情報はありません。")
                    .font(.kinjoBody())
                    .foregroundColor(.kinjoSubtext)
            } else {
                ForEach(items.prefix(3)) { item in
                    EarthquakeRow(item: item)
                }
            }
        }
        .kinjoCard()
    }
}

private struct EarthquakeRow: View {
    let item: EarthquakeItem

    private var tint: Color {
        item.magnitude >= 4.0 ? .kinjoCoral : .kinjoGold
    }

    var body: some View {
        HStack(spacing: KinjoSpacing.md) {
            VStack(spacing: 1) {
                Text("M")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                Text(String(format: "%.1f", item.magnitude))
                    .font(.system(size: 21, weight: .heavy, design: .rounded))
            }
            .foregroundColor(tint)
            .frame(width: 58, height: 58)
            .background(tint.opacity(0.13))
            .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.place)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.kinjoText)
                    .lineLimit(1)
                Text("深さ \(Int(item.depth))km ・ \(item.time.toRelativeJapanese())")
                    .font(.kinjoCaption())
                    .foregroundColor(.kinjoSubtext)
            }
            Spacer()
        }
    }
}
