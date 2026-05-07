import Foundation

struct WeatherData: Codable, Identifiable {
    var id: String { "\(lat),\(lon)" }
    let lat: Double
    let lon: Double
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let weatherCode: Int
    let description: String
    let windSpeed: Double
    let forecast: [ForecastDay]

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case cityName = "city_name"
        case temperature
        case feelsLike = "feels_like"
        case humidity
        case weatherCode = "weather_code"
        case description
        case windSpeed = "wind_speed"
        case forecast
    }
}

struct ForecastDay: Codable, Identifiable {
    var id: String { date }
    let date: String
    let maxTemp: Double
    let minTemp: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case date
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case weatherCode = "weather_code"
    }
}

struct EarthquakeItem: Codable, Identifiable {
    let id: String
    let place: String
    let magnitude: Double
    let depth: Double
    let time: String
    let lat: Double
    let lon: Double
}

struct NewsItem: Codable, Identifiable {
    let id: String
    let title: String
    let source: String
    let url: String
    let publishedAt: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, title, source, url, description
        case publishedAt = "published_at"
    }
}

struct TrainItem: Codable, Identifiable {
    let id: String
    let lineName: String
    let status: TrainStatus
    let detail: String?
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, status, detail
        case lineName = "line_name"
        case updatedAt = "updated_at"
    }
}

enum TrainStatus: String, Codable {
    case normal
    case delayed
    case stopped
    case unknown

    var label: String {
        switch self {
        case .normal: return "平常運転"
        case .delayed: return "遅延あり"
        case .stopped: return "運転見合わせ"
        case .unknown: return "確認中"
        }
    }
}

struct OnThisDay: Codable {
    let date: String
    let specialDays: [String]
    let tenYearsAgo: [HistoryEvent]
    let hundredYearsAgo: [HistoryEvent]
    let notable: [HistoryEvent]

    enum CodingKeys: String, CodingKey {
        case date, notable
        case specialDays = "special_days"
        case tenYearsAgo = "ten_years_ago"
        case hundredYearsAgo = "hundred_years_ago"
    }
}

struct HistoryEvent: Codable, Identifiable {
    let id: String
    let year: Int
    let description: String
}

struct EventItem: Codable, Identifiable {
    let id: String
    let title: String
    let place: String
    let startDate: String
    let endDate: String?
    let category: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id, title, place, category, url
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct SakuraData: Codable {
    let season: String
    let keyword: String
    let items: [SakuraItem]
}

struct SakuraItem: Codable {
    let title: String
    let link: String
    let pubDate: String
    let source: String
}

struct BikeStation: Codable, Identifiable {
    let id: String
    let name: String
    let bikesAvailable: Int
    let docksAvailable: Int
    let distanceM: Int
    let address: String

    enum CodingKeys: String, CodingKey {
        case id, name, address, distanceM
        case bikesAvailable = "availableBikes"
        case docksAvailable = "availableDocks"
    }
}

struct UVData: Codable {
    let current: Double
    let peak: Double
    let peakHour: Int
    let label: String
    let advice: String
    let color: String
    let hourly: [UVHour]
}

struct UVHour: Codable {
    let uv: Double
    let hour: Int
}

struct StoreItem: Codable, Identifiable {
    let id: String
    let title: String
    let type: String
    let link: String
    let source: String
    let relativeDate: String
}

struct AirLevel: Codable {
    let label: String
    let color: String
}

struct AirQualityData: Codable {
    let updatedAt: String
    let pm25: Double?
    let pm25Level: AirLevel
    let pollen: Int?
    let pollenLevel: AirLevel
}

struct SunriseData: Codable {
    let date: String
    let sunrise: String
    let solarNoon: String
    let sunset: String
    let dayLengthHours: Int
    let dayLengthMins: Int
}

struct FengshuiData: Codable {
    let date: String
    let color: String
    let direction: String
    let star: String
    let colorName: String
    let luckyItems: [String]
    let fortune: String
}

extension String {
    func toRelativeJapanese() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: self) {
            return date.relativeJapanese()
        }
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: self) {
            return date.relativeJapanese()
        }
        return self
    }

    func toJapaneseShortDate() -> String {
        let iso = ISO8601DateFormatter()
        var date = iso.date(from: self)
        if date == nil {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            date = df.date(from: self)
        }
        guard let date else { return self }
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "M月d日"
        return df.string(from: date)
    }
}

extension Date {
    func relativeJapanese() -> String {
        let seconds = Int(-timeIntervalSinceNow)
        if seconds < 60 { return "たった今" }
        if seconds < 3600 { return "\(seconds / 60)分前" }
        if seconds < 86400 { return "\(seconds / 3600)時間前" }
        if seconds < 604800 { return "\(seconds / 86400)日前" }

        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "M月d日"
        return df.string(from: self)
    }
}
