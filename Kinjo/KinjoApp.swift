import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

final class AdMobStartup: ObservableObject {
    static let shared = AdMobStartup()

    @Published private(set) var isReady = false
    private var didStart = false

    func requestTrackingAndStartAds() {
        guard !didStart else { return }
        didStart = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                DispatchQueue.main.async {
                    MobileAds.shared.start(completionHandler: nil)
                    self.isReady = true
                }
            }
        }
    }
}

@main
struct KinjoApp: App {
    @StateObject private var adMobStartup = AdMobStartup.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    adMobStartup.requestTrackingAndStartAds()
                }
        }
    }
}
