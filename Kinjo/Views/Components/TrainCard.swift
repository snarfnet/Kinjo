import SwiftUI

struct TrainCard: View {
    let items: [TrainItem]

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "電車と交通", subtitle: "通勤・通学前のひと目チェック", icon: "tram.fill", tint: .kinjoTeal)

            ForEach(items) { item in
                HStack(spacing: KinjoSpacing.sm) {
                    Image(systemName: icon(for: item.status))
                        .foregroundColor(color(for: item.status))
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.lineName)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.kinjoText)
                        if let detail = item.detail, !detail.isEmpty {
                            Text(detail)
                                .font(.kinjoCaption())
                                .foregroundColor(.kinjoSubtext)
                                .lineLimit(2)
                        }
                    }
                    Spacer()
                    Text(item.status.label)
                        .font(.kinjoCaption())
                        .foregroundColor(color(for: item.status))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(color(for: item.status).opacity(0.12))
                        .clipShape(Capsule())
                }
                .padding(12)
                .background(Color.kinjoTeal.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
            }
        }
        .kinjoCard()
    }

    private func color(for status: TrainStatus) -> Color {
        switch status {
        case .normal: return .kinjoGreen
        case .delayed: return .kinjoGold
        case .stopped: return .kinjoCoral
        case .unknown: return .kinjoSubtext
        }
    }

    private func icon(for status: TrainStatus) -> String {
        switch status {
        case .normal: return "checkmark.circle.fill"
        case .delayed: return "clock.badge.exclamationmark.fill"
        case .stopped: return "xmark.octagon.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}
