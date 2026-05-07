import SwiftUI

struct AirQualityCard: View {
    let data: AirQualityData

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "空気と花粉", subtitle: data.updatedAt.toRelativeJapanese(), icon: "aqi.medium", tint: .kinjoTeal)
            HStack(spacing: KinjoSpacing.sm) {
                AirQualityCell(icon: "aqi.medium", title: "PM2.5", value: data.pm25.map { String(format: "%.1f", $0) } ?? "--", unit: "μg/m³", label: data.pm25Level.label, tint: levelColor(data.pm25Level.color))
                AirQualityCell(icon: "leaf.fill", title: "花粉", value: data.pollen.map(String.init) ?? "--", unit: "個/m³", label: data.pollenLevel.label, tint: levelColor(data.pollenLevel.color))
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
        default: return .kinjoTeal
        }
    }
}

private struct AirQualityCell: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let label: String
    let tint: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(tint)
            Text(title)
                .font(.kinjoCaption())
                .foregroundColor(.kinjoSubtext)
            Text(value)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundColor(.kinjoText)
            Text("\(unit) ・ \(label)")
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(tint)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(tint.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
    }
}
