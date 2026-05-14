import SwiftUI

struct NewsCard: View {
    let items: [NewsItem]
    let title: String

    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "\(title) \(items.count)件", subtitle: "暮らしに関わる話題をまとめて表示します", icon: "newspaper.fill", tint: .kinjoCoral)

            ForEach(items) { item in
                Button {
                    if let url = URL(string: item.url) {
                        openURL(url)
                    }
                } label: {
                    NewsRow(item: item)
                }
                .buttonStyle(.plain)
            }
        }
        .kinjoCard()
    }
}

private struct NewsRow: View {
    let item: NewsItem

    var body: some View {
        HStack(alignment: .top, spacing: KinjoSpacing.sm) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color.kinjoCoral)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.kinjoText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 8) {
                    Text(item.source)
                        .font(.kinjoCaption())
                        .foregroundColor(.kinjoCoral)
                    Text(item.publishedAt.toRelativeJapanese())
                        .font(.kinjoCaption())
                        .foregroundColor(.kinjoSubtext)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.kinjoSubtext.opacity(0.6))
                }
            }
        }
        .padding(12)
        .background(Color.kinjoCoral.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
    }
}
