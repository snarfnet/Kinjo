import SwiftUI

struct OnThisDayCard: View {
    let onThisDay: OnThisDay

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "今日にまつわる話", subtitle: "街歩きの小さな会話のきっかけに", icon: "book.closed.fill", tint: .kinjoInk)

            HistorySubCard(title: "10年前の今日", events: onThisDay.tenYearsAgo, tint: .kinjoTeal)
            HistorySubCard(title: "100年前の今日", events: onThisDay.hundredYearsAgo, tint: .kinjoGold)
        }
        .kinjoCard()
    }
}

private struct HistorySubCard: View {
    let title: String
    let events: [HistoryEvent]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.sm) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(tint)
            ForEach(events.prefix(2)) { event in
                HStack(alignment: .top, spacing: KinjoSpacing.sm) {
                    Text("\(event.year)")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundColor(tint)
                        .frame(width: 44, alignment: .leading)
                    Text(event.description)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.kinjoText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
    }
}
