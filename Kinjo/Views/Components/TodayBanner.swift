import SwiftUI

struct TodayBanner: View {
    let onThisDay: OnThisDay

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日 EEEE"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("今日の街メモ")
                        .font(.kinjoHeadline())
                        .foregroundColor(.kinjoText)
                    Text(dateString)
                        .font(.kinjoCaption())
                        .foregroundColor(.kinjoSubtext)
                }
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.kinjoGold)
            }

            if !onThisDay.specialDays.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: KinjoSpacing.sm) {
                        ForEach(onThisDay.specialDays, id: \.self) { day in
                            SpecialDayPill(text: day)
                        }
                    }
                }
            }
        }
        .kinjoCard()
    }
}

struct SpecialDayPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundColor(.kinjoInk)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.kinjoGold.opacity(0.14))
            .clipShape(Capsule())
    }
}
