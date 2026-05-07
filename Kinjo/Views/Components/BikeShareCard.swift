import SwiftUI

struct BikeShareCard: View {
    let stations: [BikeStation]

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "近くのシェアサイクル", subtitle: "空き状況と距離をすばやく確認", icon: "bicycle", tint: .kinjoGreen)

            if stations.isEmpty {
                Text("近くのステーションはまだ見つかっていません。")
                    .font(.kinjoBody())
                    .foregroundColor(.kinjoSubtext)
            } else {
                ForEach(stations.prefix(4)) { station in
                    HStack(spacing: KinjoSpacing.sm) {
                        Image(systemName: "bicycle")
                            .foregroundColor(station.bikesAvailable > 0 ? .kinjoGreen : .kinjoSubtext)
                            .frame(width: 32, height: 32)
                            .background((station.bikesAvailable > 0 ? Color.kinjoGreen : Color.kinjoSubtext).opacity(0.12))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(station.name)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.kinjoText)
                            Text("自転車 \(station.bikesAvailable)台 ・ 空き \(station.docksAvailable)台")
                                .font(.kinjoCaption())
                                .foregroundColor(.kinjoSubtext)
                        }
                        Spacer()
                        Text(distanceLabel(station.distanceM))
                            .font(.kinjoCaption())
                            .foregroundColor(.kinjoTeal)
                    }
                }
            }
        }
        .kinjoCard()
    }

    private func distanceLabel(_ meters: Int) -> String {
        meters < 1000 ? "\(meters)m" : String(format: "%.1fkm", Double(meters) / 1000)
    }
}
