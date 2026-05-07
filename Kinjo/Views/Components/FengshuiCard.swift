import SwiftUI

struct FengshuiCard: View {
    let data: FengshuiData

    private var tint: Color { Color(hex: data.color) }

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "今日の方角メモ", subtitle: data.fortune, icon: "location.north.line.fill", tint: tint)

            HStack(spacing: KinjoSpacing.md) {
                CompassBadge(direction: data.direction, tint: tint)
                    .frame(width: 86, height: 86)

                VStack(alignment: .leading, spacing: 7) {
                    Text(data.star)
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundColor(tint)
                    Text("よい方角: \(data.direction)")
                        .font(.kinjoBody())
                        .foregroundColor(.kinjoText)
                    Text("ラッキーカラー: \(data.colorName)")
                        .font(.kinjoCaption())
                        .foregroundColor(.kinjoSubtext)
                    if let item = data.luckyItems.first {
                        Text("持ち物: \(item)")
                            .font(.kinjoCaption())
                            .foregroundColor(.kinjoSubtext)
                    }
                }
                Spacer()
            }
        }
        .kinjoCard()
    }
}

private struct CompassBadge: View {
    let direction: String
    let tint: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(0.1))
            Circle()
                .stroke(tint.opacity(0.3), lineWidth: 1.5)
            Image(systemName: "location.north.fill")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(tint)
            Text(direction)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(tint)
                .offset(y: 29)
        }
    }
}
