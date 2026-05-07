import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URLが正しくありません。"
        case .invalidResponse(let code): return "サーバーエラー: \(code)"
        case .decodingError(let error): return "データを読み取れませんでした: \(error.localizedDescription)"
        case .networkError(let error): return "通信エラー: \(error.localizedDescription)"
        }
    }
}

final class APIService {
    static let shared = APIService()

    private let baseURL = "https://backend-mu-one-z83zhj2wah.vercel.app"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        session = URLSession(configuration: config)
    }

    private func fetch<T: Decodable>(_ path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        var components = URLComponents(string: baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else { throw APIError.invalidURL }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw APIError.networkError(error)
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.invalidResponse(statusCode: http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        if isPreview { return MockData.weather }
        return try await fetch("/api/weather", queryItems: [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon))
        ])
    }

    func fetchEarthquakes() async throws -> [EarthquakeItem] {
        if isPreview { return MockData.earthquakes }
        return try await fetch("/api/earthquakes")
    }

    func fetchNews(city: String) async throws -> [NewsItem] {
        if isPreview { return MockData.news }
        return try await fetch("/api/news", queryItems: [URLQueryItem(name: "city", value: city)])
    }

    func fetchTrains() async throws -> [TrainItem] {
        if isPreview { return MockData.trains }
        return try await fetch("/api/trains")
    }

    func fetchOnThisDay() async throws -> OnThisDay {
        if isPreview { return MockData.onThisDay }
        return try await fetch("/api/onThisDay")
    }

    func fetchEvents(city: String) async throws -> [EventItem] {
        if isPreview { return MockData.events }
        return try await fetch("/api/events", queryItems: [URLQueryItem(name: "city", value: city)])
    }

    func fetchSakura(city: String) async throws -> SakuraData {
        if isPreview { return MockData.sakura }
        return try await fetch("/api/sakura", queryItems: [URLQueryItem(name: "city", value: city)])
    }

    func fetchBikeShare(lat: Double, lon: Double) async throws -> [BikeStation] {
        if isPreview { return MockData.bikeStations }
        return try await fetch("/api/bikeShare", queryItems: [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "radius", value: "1.0")
        ])
    }

    func fetchUV(lat: Double, lon: Double) async throws -> UVData {
        if isPreview { return MockData.uv }
        return try await fetch("/api/uv", queryItems: [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon))
        ])
    }

    func fetchStores(city: String) async throws -> [StoreItem] {
        if isPreview { return MockData.stores }
        return try await fetch("/api/stores", queryItems: [URLQueryItem(name: "city", value: city)])
    }

    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

enum MockData {
    static let weather = WeatherData(
        lat: 35.6895,
        lon: 139.6917,
        cityName: "東京",
        temperature: 22.4,
        feelsLike: 21.0,
        humidity: 58,
        weatherCode: 1,
        description: "晴れ時々くもり",
        windSpeed: 3.5,
        forecast: [
            ForecastDay(date: "2026-05-08", maxTemp: 24.0, minTemp: 16.0, weatherCode: 0),
            ForecastDay(date: "2026-05-09", maxTemp: 21.0, minTemp: 15.0, weatherCode: 61),
            ForecastDay(date: "2026-05-10", maxTemp: 23.0, minTemp: 17.0, weatherCode: 3)
        ]
    )

    static let earthquakes = [
        EarthquakeItem(id: "eq1", place: "千葉県北西部", magnitude: 3.2, depth: 70, time: "2026-05-08T08:23:00Z", lat: 35.6, lon: 140.1),
        EarthquakeItem(id: "eq2", place: "茨城県南部", magnitude: 2.8, depth: 50, time: "2026-05-08T03:14:00Z", lat: 36.1, lon: 140.3),
        EarthquakeItem(id: "eq3", place: "東京湾", magnitude: 4.1, depth: 80, time: "2026-05-07T21:05:00Z", lat: 35.5, lon: 139.8)
    ]

    static let news = [
        NewsItem(id: "n1", title: "区内の公園に見守り灯を増設。夜の帰り道を明るく", source: "地域ニュース", url: "https://example.com/1", publishedAt: "2026-05-08T06:00:00Z", description: "通学路と駅前通りを中心に整備が進みます。"),
        NewsItem(id: "n2", title: "週末は駅前広場で防災フェア。親子で備えを確認", source: "自治体広報", url: "https://example.com/2", publishedAt: "2026-05-08T05:30:00Z", description: nil),
        NewsItem(id: "n3", title: "商店街で朝市を開催。地元野菜と焼きたてパンが並ぶ予定", source: "街の掲示板", url: "https://example.com/3", publishedAt: "2026-05-07T23:45:00Z", description: nil),
        NewsItem(id: "n4", title: "駅前道路の一部で夜間工事。歩行ルートを確認してください", source: "交通情報", url: "https://example.com/4", publishedAt: "2026-05-07T20:00:00Z", description: nil)
    ]

    static let trains = [
        TrainItem(id: "t1", lineName: "山手線", status: .normal, detail: nil, updatedAt: "2026-05-08T09:00:00Z"),
        TrainItem(id: "t2", lineName: "中央線快速", status: .delayed, detail: "混雑のため一部列車に遅れ", updatedAt: "2026-05-08T08:55:00Z"),
        TrainItem(id: "t3", lineName: "東急東横線", status: .normal, detail: nil, updatedAt: "2026-05-08T09:00:00Z")
    ]

    static let onThisDay = OnThisDay(
        date: "5月8日",
        specialDays: ["ごみゼロの日", "世界赤十字デー"],
        tenYearsAgo: [
            HistoryEvent(id: "h1", year: 2016, description: "熊本地震の被災地支援が全国から続きました。"),
            HistoryEvent(id: "h2", year: 2016, description: "地域の防災意識を高める取り組みが広がりました。")
        ],
        hundredYearsAgo: [
            HistoryEvent(id: "h3", year: 1926, description: "都市の暮らしを支える交通と公園整備が進みました。")
        ],
        notable: []
    )

    static let sakura = SakuraData(
        season: "sakura",
        keyword: "東京 桜",
        items: [
            SakuraItem(title: "近くの公園で新緑が見頃。散歩にちょうどよい季節です", link: "https://example.com/sakura1", pubDate: "2026-05-07T09:00:00Z", source: "散歩情報"),
            SakuraItem(title: "春の花壇整備ボランティアを募集", link: "https://example.com/sakura2", pubDate: "2026-05-06T12:00:00Z", source: "地域掲示板")
        ]
    )

    static let bikeStations = [
        BikeStation(id: "b1", name: "駅前ポート", bikesAvailable: 5, docksAvailable: 10, distanceM: 250, address: "駅前通り"),
        BikeStation(id: "b2", name: "図書館前ポート", bikesAvailable: 2, docksAvailable: 8, distanceM: 680, address: "中央図書館前")
    ]

    static let uv = UVData(
        current: 4.2,
        peak: 7.8,
        peakHour: 12,
        label: "中程度",
        advice: "昼前後は日焼け止めを",
        color: "yellow",
        hourly: (0..<24).map { hour in
            let value = hour >= 6 && hour <= 18 ? Double(hour >= 12 ? 24 - hour : hour) * 0.5 : 0.0
            return UVHour(uv: value, hour: hour)
        }
    )

    static let stores = [
        StoreItem(id: "s1", title: "駅前に新しいベーカリーがオープン", type: "open", link: "https://example.com/store1", source: "街の掲示板", relativeDate: "2日前"),
        StoreItem(id: "s2", title: "商店街のカフェが改装のため一時休業", type: "renovate", link: "https://example.com/store2", source: "地域情報", relativeDate: "5日前")
    ]

    static let events = [
        EventItem(id: "e1", title: "公園マルシェ", place: "中央公園", startDate: "2026-05-10", endDate: "2026-05-10", category: "マルシェ", url: "https://example.com/ev1"),
        EventItem(id: "e2", title: "親子防災ワークショップ", place: "区民センター", startDate: "2026-05-12", endDate: nil, category: "防災", url: "https://example.com/ev2"),
        EventItem(id: "e3", title: "商店街スタンプラリー", place: "駅前商店街", startDate: "2026-05-15", endDate: "2026-05-18", category: "地域", url: nil)
    ]
}
