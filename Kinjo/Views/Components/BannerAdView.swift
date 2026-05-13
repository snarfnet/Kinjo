import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    init(adUnitID: String = AdMobConfig.bannerTopID) {
        self.adUnitID = adUnitID
    }

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.adRootViewController
        return banner
    }

    func updateUIView(_ banner: BannerView, context: Context) {
        banner.adUnitID = adUnitID
        if banner.rootViewController == nil {
            banner.rootViewController = UIApplication.shared.adRootViewController
        }
        if context.coordinator.loadedAdUnitID != adUnitID {
            context.coordinator.loadedAdUnitID = adUnitID
            banner.load(Request())
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var loadedAdUnitID: String?
    }
}

struct BannerAdContainer: View {
    let adUnitID: String
    @ObservedObject private var adMobStartup = AdMobStartup.shared

    init(adUnitID: String = AdMobConfig.bannerTopID) {
        self.adUnitID = adUnitID
    }

    var body: some View {
        Group {
            if adMobStartup.isReady {
                BannerAdView(adUnitID: adUnitID)
            } else {
                adPlaceholder
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(Color.kinjoBackground)
        .accessibilityLabel("広告")
    }

    private var adPlaceholder: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.06))
            Text("広告")
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color.kinjoSubtext)
        }
    }
}

private extension UIApplication {
    var adRootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
