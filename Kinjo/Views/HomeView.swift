import SwiftUI

@MainActor
struct HomeView: View {
    @StateObject private var locationService = LocationService()

    @State private var weather: WeatherData?
    @State private var earthquakes: [EarthquakeItem] = []
    @State private var news: [NewsItem] = []
    @State private var trains: [TrainItem] = []
    @State private var onThisDay: OnThisDay?
    @State private var events: [EventItem] = []
    @State private var sakura: SakuraData?
    @State private var bikeStations: [BikeStation] = []
    @State private var uvData: UVData?
    @State private var stores: [StoreItem] = []
    @State private var isLoading = true

    private let api = APIService.shared

    var body: some View {
        ScrollView {
            LazyVStack(spacing: KinjoSpacing.md) {
                KinjoHeroHeader(cityName: locationService.cityName)
                    .padding(.horizontal, KinjoSpacing.md)
                    .padding(.top, KinjoSpacing.sm)

                if isLoading {
                    loadingView
                } else {
                    contentView
                }

                BannerAdContainer(adUnitID: AdMobConfig.bannerBottomID)
                    .padding(.horizontal, KinjoSpacing.md)

                Color.clear.frame(height: KinjoSpacing.xl)
            }
        }
        .background(KinjoBackground())
        .refreshable { await loadAll() }
        .task {
            locationService.requestPermission()
            await loadAll()
        }
        .navigationTitle("近所")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { await loadAll() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .bold))
                }
                .tint(.kinjoTeal)
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: KinjoSpacing.md) {
            ForEach(0..<4, id: \.self) { _ in
                CardSkeletonView()
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        safeSummary
            .padding(.horizontal, KinjoSpacing.md)

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: KinjoSpacing.md) {
                KinjoArtworkCard(imageName: "kinjo-safety-map", title: "安心の見える化", caption: "地震・交通・空気をまとめて確認")
                    .frame(width: 260)
                KinjoArtworkCard(imageName: "kinjo-local-life", title: "街の動き", caption: "お店、イベント、ニュースを一目で")
                    .frame(width: 260)
                KinjoArtworkCard(imageName: "kinjo-weather", title: "今日の備え", caption: "天気と紫外線を暮らし目線で")
                    .frame(width: 260)
            }
            .padding(.horizontal, KinjoSpacing.md)
        }

        if let weather {
            WeatherCard(weather: weather, cityName: locationService.cityName)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if let onThisDay {
            TodayBanner(onThisDay: onThisDay)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if !news.isEmpty {
            NewsCard(items: Array(news.prefix(3)), title: "近所のニュース")
                .padding(.horizontal, KinjoSpacing.md)
        }

        BannerAdContainer(adUnitID: AdMobConfig.bannerTopID)
            .padding(.horizontal, KinjoSpacing.md)

        if let uvData {
            UVCard(data: uvData)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if !earthquakes.isEmpty {
            EarthquakeCard(items: earthquakes)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if !stores.isEmpty {
            StoreCard(items: stores)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if !trains.isEmpty {
            TrainCard(items: trains)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if !events.isEmpty {
            EventCard(items: events)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if let onThisDay {
            OnThisDayCard(onThisDay: onThisDay)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if let sakura, sakura.season != "off" {
            SakuraCard(data: sakura)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if !bikeStations.isEmpty {
            BikeShareCard(stations: bikeStations)
                .padding(.horizontal, KinjoSpacing.md)
        }

        if news.count > 3 {
            NewsCard(items: Array(news.dropFirst(3)), title: "もっと見る")
                .padding(.horizontal, KinjoSpacing.md)
        }
    }

    private var safeSummary: some View {
        HStack(spacing: KinjoSpacing.sm) {
            StatusPill(icon: "checkmark.shield.fill", title: "街の状況", value: "確認済み", tint: .kinjoGreen)
            StatusPill(icon: "tram.fill", title: "交通", value: trains.contains { $0.status != .normal } ? "注意" : "平常", tint: trains.contains { $0.status != .normal } ? .kinjoGold : .kinjoTeal)
            StatusPill(icon: "bell.badge.fill", title: "防災", value: earthquakes.isEmpty ? "静か" : "\(earthquakes.count)件", tint: .kinjoCoral)
        }
    }

    func loadAll() async {
        isLoading = true

        let lat = locationService.location?.coordinate.latitude ?? 35.6895
        let lon = locationService.location?.coordinate.longitude ?? 139.6917
        let city = locationService.cityName

        do { weather = try await api.fetchWeather(lat: lat, lon: lon) } catch { weather = MockData.weather }
        do { earthquakes = try await api.fetchEarthquakes() } catch { earthquakes = MockData.earthquakes }
        do { news = try await api.fetchNews(city: city) } catch { news = MockData.news }
        do { trains = try await api.fetchTrains() } catch { trains = MockData.trains }
        do { onThisDay = try await api.fetchOnThisDay() } catch { onThisDay = MockData.onThisDay }
        do { events = try await api.fetchEvents(city: city) } catch { events = MockData.events }
        do { uvData = try await api.fetchUV(lat: lat, lon: lon) } catch { uvData = MockData.uv }
        do { stores = try await api.fetchStores(city: city) } catch { stores = MockData.stores }
        do { sakura = try await api.fetchSakura(city: city) } catch { sakura = MockData.sakura }
        do { bikeStations = try await api.fetchBikeShare(lat: lat, lon: lon) } catch { bikeStations = MockData.bikeStations }

        isLoading = false
    }
}

private struct StatusPill: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(tint)
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(.kinjoSubtext)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.kinjoText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .kinjoCard(padding: 12)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
