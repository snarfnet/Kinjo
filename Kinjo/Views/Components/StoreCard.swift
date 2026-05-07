import SwiftUI

struct StoreCard: View {
    let items: [StoreItem]
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "お店の動き", subtitle: "開店・改装など、街の変化を確認", icon: "storefront.fill", tint: .kinjoGold)

            Image("kinjo-local-life")
                .resizable()
                .scaledToFill()
                .frame(height: 130)
                .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.lg, style: .continuous))

            ForEach(items.prefix(5)) { item in
                Button {
                    if let url = URL(string: item.link) {
                        openURL(url)
                    }
                } label: {
                    HStack(spacing: KinjoSpacing.sm) {
                        Image(systemName: icon(for: item.type))
                            .foregroundColor(color(for: item.type))
                            .frame(width: 32, height: 32)
                            .background(color(for: item.type).opacity(0.12))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.kinjoText)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            Text("\(label(for: item.type)) ・ \(item.source) ・ \(item.relativeDate)")
                                .font(.kinjoCaption())
                                .foregroundColor(.kinjoSubtext)
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .kinjoCard()
    }

    private func icon(for type: String) -> String {
        switch type {
        case "open": return "sparkles"
        case "close": return "moon.zzz.fill"
        case "renovate": return "paintbrush.pointed.fill"
        default: return "info.circle.fill"
        }
    }

    private func label(for type: String) -> String {
        switch type {
        case "open": return "開店"
        case "close": return "閉店"
        case "renovate": return "改装"
        default: return "情報"
        }
    }

    private func color(for type: String) -> Color {
        switch type {
        case "open": return .kinjoGreen
        case "close": return .kinjoCoral
        case "renovate": return .kinjoGold
        default: return .kinjoTeal
        }
    }
}
