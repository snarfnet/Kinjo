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
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        guard uiView.rootViewController == nil else { return }
        if let rootVC = uiView.window?.rootViewController {
            uiView.rootViewController = rootVC
            uiView.load(GADRequest())
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
