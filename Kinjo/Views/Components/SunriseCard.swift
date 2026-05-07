import SwiftUI

struct SunriseCard: View {
    let data: SunriseData

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "日の出と日の入り", subtitle: data.date, icon: "sunrise.fill", tint: .kinjoGold)
            HStack(spacing: KinjoSpacing.sm) {
                SunCell(icon: "sunrise.fill", label: "日の出", value: data.sunrise, tint: .kinjoGold)
                SunCell(icon: "sun.max.fill", label: "南中", value: data.solarNoon, tint: .kinjoCoral)
                SunCell(icon: "sunset.fill", label: "日の入り", value: data.sunset, tint: .kinjoTeal)
                SunCell(icon: "clock.fill", label: "昼の長さ", value: "\(data.dayLengthHours)h\(data.dayLengthMins)m", tint: .kinjoBlue)
            }
        }
        .kinjoCard()
    }
}

private struct SunCell: View {
    let icon: String
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(tint)
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.kinjoSubtext)
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.kinjoText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(tint.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
    }
}
