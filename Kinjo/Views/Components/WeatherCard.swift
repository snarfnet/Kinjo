import SwiftUI

extension Int {
    var weatherIcon: String {
        switch self {
        case 0: return "sun.max.fill"
        case 1...3: return "cloud.sun.fill"
        case 45...48: return "cloud.fog.fill"
        case 51...67: return "cloud.rain.fill"
        case 71...77: return "snowflake"
        case 80...82: return "cloud.sun.rain.fill"
        case 95...99: return "cloud.bolt.rain.fill"
        default: return "cloud.fill"
        }
    }

    var weatherLabel: String {
        switch self {
        case 0: return "晴れ"
        case 1...3: return "くもり"
        case 45...48: return "霧"
        case 51...67: return "雨"
        case 71...77: return "雪"
        case 80...82: return "にわか雨"
        case 95...99: return "雷雨"
        default: return "くもり"
        }
    }
}

struct WeatherCard: View {
    let weather: WeatherData
    let cityName: String

    var body: some View {
        VStack(alignment: .leading, spacing: KinjoSpacing.md) {
            KinjoCardHeader(title: "今日の天気", subtitle: "外出前に、暑さと風を確認", icon: "cloud.sun.fill", tint: .kinjoBlue)

            HStack(alignment: .center, spacing: KinjoSpacing.md) {
                ZStack {
                    Image("kinjo-weather")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 112, height: 112)
                        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.lg, style: .continuous))
                    Image(systemName: weather.weatherCode.weatherIcon)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 3)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(cityName.isEmpty ? weather.cityName : cityName)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.kinjoSubtext)
                    Text("\(Int(weather.temperature.rounded()))°")
                        .font(.system(size: 54, weight: .heavy, design: .rounded))
                        .foregroundColor(.kinjoText)
                    Text(weather.weatherCode.weatherLabel)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.kinjoBlue)
                }
                Spacer()
            }

            HStack(spacing: KinjoSpacing.sm) {
                WeatherMetric(icon: "thermometer.medium", label: "体感", value: "\(Int(weather.feelsLike.rounded()))°")
                WeatherMetric(icon: "humidity.fill", label: "湿度", value: "\(weather.humidity)%")
                WeatherMetric(icon: "wind", label: "風", value: String(format: "%.1fm", weather.windSpeed))
            }

            HStack(spacing: 0) {
                ForEach(weather.forecast) { day in
                    ForecastDayCell(day: day)
                }
            }
            .padding(.top, 2)
        }
        .kinjoCard()
    }
}

private struct WeatherMetric: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.kinjoTeal)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.kinjoText)
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.kinjoSubtext)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.kinjoTeal.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: KinjoRadius.md, style: .continuous))
    }
}

struct ForecastDayCell: View {
    let day: ForecastDay

    private var dayLabel: String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"
        input.locale = Locale(identifier: "ja_JP")
        guard let date = input.date(from: day.date) else { return day.date }
        let output = DateFormatter()
        output.locale = Locale(identifier: "ja_JP")
        output.dateFormat = "E"
        return output.string(from: date)
    }

    var body: some View {
        VStack(spacing: 5) {
            Text(dayLabel)
                .font(.kinjoCaption())
                .foregroundColor(.kinjoSubtext)
            Image(systemName: day.weatherCode.weatherIcon)
                .foregroundColor(.kinjoGold)
            Text("\(Int(day.maxTemp.rounded()))° / \(Int(day.minTemp.rounded()))°")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.kinjoText)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WeatherCard(weather: MockData.weather, cityName: "東京")
        .padding()
        .background(KinjoBackground())
}
