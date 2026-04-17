//
//  BannerViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by admin on 2025/9/8.
//

import UIKit
import AdSurgeSDK
import Foundation

class BannerViewController: BaseAdViewController, AdSurgeBannerAdDelegate {

    var bannerView: AdSurgeBannerAdView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitIdTitles = [
            "Banner 15884",
            "MREC 15877"
        ];
        self.unitIds = [
            "15884",
            "15877"
        ]
        self.unitId = unitIds.first
        removeShowButton()
    }

    override func loadAd() {
        if let banner = bannerView, banner.superview != nil {
        banner.removeFromSuperview()
        bannerView = nil
        }
        let localBanner = AdSurgeBannerAdView(adUnitIdentifier: unitId ?? "15884")
        localBanner.viewController = self
        localBanner.delegate = self
        self.bannerView = localBanner

        var rect = CGRect(x: 10, y: 200, width: 320, height: 50)
        if UIDevice.current.userInterfaceIdiom == .pad {
            rect = CGRect(x: 10, y: 200, width: 728, height: 90)
        }
        self.bannerView.frame = rect

        if let banner = self.bannerView {
            view.addSubview(banner)
        }

        let adConfig = AdSurgeAdConfig(adFormat: .banner)
        bannerView.loadAd(adConfig)
    }
    
    // MARK: - AdSurgeRewardedAdDelegate

    func didLoad(_ ad: AdSurgeAd) {
        print(#function)
        print("ad's format: \(ad.format.label), adUnitIdentifier: \(ad.adUnitIdentifier), revenue: \(ad.revenue)")
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: AdSurgeError) {
        print(#function)
        print("ad's adUnitIdentifier: \(adUnitIdentifier), error: \(error)")
    }

    func didHide(_ ad: AdSurgeAd) {
        print(#function)
    }

    func didClick(_ ad: AdSurgeAd) {
        print(#function)
    }

    func didPayRevenue(for ad: AdSurgeAd) {
        print(#function)
    }
}
