import SwiftUI

struct SakuraCard: View {
    let data: SakuraData
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: data.season == "koyo" ? "紅葉と散歩" : "季節の散歩", subtitle: "近くの花や公園の話題", icon: "leaf.fill", tint: .kinjoGreen)

            ForEach(Array(data.items.prefix(3).enumerated()), id: \.offset) { _, item in
                Button {
                    if let url = URL(string: item.link) {
                        openURL(url)
                    }
                } label: {
                    HStack(alignment: .top, spacing: KinjoSpacing.sm) {
                        Image(systemName: "leaf.circle.fill")
                            .foregroundColor(.kinjoGreen)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.kinjoText)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            Text("\(item.source) ・ \(item.pubDate.toRelativeJapanese())")
                                .font(.kinjoCaption())
                                .foregroundColor(.kinjoSubtext)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .kinjoCard()
    }
}
