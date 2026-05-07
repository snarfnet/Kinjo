import SwiftUI

struct UVCard: View {
    let data: UVData

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "紫外線", subtitle: data.advice, icon: "sun.max.fill", tint: levelColor(data.color))

            HStack(spacing: KinjoSpacing.sm) {
                UVMetric(title: "いま", value: String(format: "%.1f", data.current), note: data.label, tint: levelColor(data.color))
                UVMetric(title: "ピーク", value: String(format: "%.1f", data.peak), note: "\(data.peakHour)時ごろ", tint: .kinjoGold)
                UVBarChart(hourly: data.hourly)
                    .frame(height: 76)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.kinjoInk.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
            }
        }
        .kinjoCard()
    }

    private func levelColor(_ value: String) -> Color {
        switch value {
        case "green": return .kinjoGreen
        case "yellow": return .kinjoGold
        case "orange": return .orange
        case "red": return .kinjoCoral
        case "purple": return .purple
        default: return .kinjoTeal
        }
    }
}

private struct UVMetric: View {
    let title: String
    let value: String
    let note: String
    let tint: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.kinjoCaption())
                .foregroundColor(.kinjoSubtext)
            Text(value)
                .font(.system(size: 25, weight: .heavy, design: .rounded))
                .foregroundColor(tint)
            Text(note)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.kinjoText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(tint.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
    }
}

private struct UVBarChart: View {
    let hourly: [UVHour]

    var body: some View {
        GeometryReader { geo in
            let maxUV = max(1.0, hourly.map(\.uv).max() ?? 1)
            let barWidth = max(2, geo.size.width / CGFloat(max(hourly.count, 1)) - 2)
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(Array(hourly.enumerated()), id: \.offset) { _, hour in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(hour.uv > 6 ? Color.kinjoCoral : Color.kinjoGold)
                        .frame(width: barWidth, height: max(4, CGFloat(hour.uv / maxUV) * geo.size.height))
                }
            }
        }
    }
}
