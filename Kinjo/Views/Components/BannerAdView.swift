import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    init(adUnitID: String = AdMobConfig.bannerTopID) {
        self.adUnitID = adUnitID
    }

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = context.coordinator.rootViewController
        banner.delegate = context.coordinator
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, BannerViewDelegate {
        var rootViewController: UIViewController? {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }

        func bannerView(_ bannerView: BannerView,
                        didFailToReceiveAdWithError error: Error) {
            print("[AdMob] Banner failed: \(error.localizedDescription)")
        }
    }
}

struct BannerAdContainer: View {
    let adUnitID: String

    init(adUnitID: String = AdMobConfig.bannerTopID) {
        self.adUnitID = adUnitID
    }

    var body: some View {
        BannerAdView(adUnitID: adUnitID)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.kinjoBackground)
    }
}
