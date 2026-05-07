import SwiftUI

struct EventCard: View {
    let items: [EventItem]
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "近くのイベント", subtitle: "週末の予定を探しやすく", icon: "calendar", tint: .kinjoGreen)

            ForEach(items.prefix(4)) { item in
                Button {
                    if let urlString = item.url, let url = URL(string: urlString) {
                        openURL(url)
                    }
                } label: {
                    EventRow(item: item)
                }
                .buttonStyle(.plain)
            }
        }
        .kinjoCard()
    }
}

private struct EventRow: View {
    let item: EventItem

    var body: some View {
        HStack(spacing: KinjoSpacing.md) {
            VStack(spacing: 2) {
                Text(month)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(day)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
            }
            .frame(width: 58, height: 58)
            .background(Color.kinjoGreen)
            .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.kinjoText)
                    .lineLimit(2)
                Text("\(item.place) ・ \(item.category ?? "地域")")
                    .font(.kinjoCaption())
                    .foregroundColor(.kinjoSubtext)
            }
            Spacer()
        }
    }

    private var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: item.startDate)
    }

    private var month: String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月"
        return formatter.string(from: date)
    }

    private var day: String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
