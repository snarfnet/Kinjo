import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    init(adUnitID: String = AdMobConfig.bannerTopID) {
        self.adUnitID = adUnitID
    }

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = context.coordinator.rootViewController
        banner.delegate = context.coordinator
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, GADBannerViewDelegate {
        /// Find the root view controller for presenting ads
        var rootViewController: UIViewController? {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }

        func bannerView(_ bannerView: GADBannerView,
                        didFailToReceiveAdWithError error: Error) {
            print("[AdMob] Banner failed: \(error.localizedDescription)")
        }
    }
}

/// Fixed-height container for banner ads, with a warm cream background fallback
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
