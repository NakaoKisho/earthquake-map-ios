//
//  BannerContentView.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/17.
//

import GoogleMobileAds
import SwiftUI

struct BannerContentView: View {
    var body: some View {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: 375)
        BannerViewContainer(adSize)
            .frame(width: adSize.size.width, height: adSize.size.height)
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    typealias UIViewType = BannerView
    let adSize: AdSize
    
    init(_ adSize: AdSize) {
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        let adUnitId = Bundle.main.object(
            forInfoDictionaryKey: "GADApplicationIdentifier"
        ) as? String
        banner.adUnitID = adUnitId ?? "ca-app-pub-3940256099942544/2435281174"
        banner.load(Request())
        banner.delegate = context.coordinator
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
    
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    
    class BannerCoordinator: NSObject, BannerViewDelegate {
        
        let parent: BannerViewContainer
        
        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }
    }
}
