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
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        guard uiView.rootViewController == nil else { return }
        if let windowScene = uiView.window?.windowScene,
           let rootVC = windowScene.keyWindow?.rootViewController {
            uiView.rootViewController = rootVC
            uiView.load(Request())
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
