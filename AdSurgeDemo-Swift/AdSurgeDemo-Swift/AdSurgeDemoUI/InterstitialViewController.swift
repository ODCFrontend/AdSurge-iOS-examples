//
//  InterstitialViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by katie on 2025/6/5.
//

import UIKit
import AdSurgeSDK

class InterstitialViewController: BaseAdViewController, AdSurgeInterstitialAdDelegate {

    var interstitialAd: AdSurgeInterstitialAd!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitIdTitles = [
            "General 10857",
        ];
        self.unitIds = [
            "10857",
        ]
        self.unitId = unitIds.first
    }

    override func setNavigationBar() {
        let label = UILabel()
        label.text = "InterstitialAD"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        self.navigationItem.titleView = label
    }

    override func loadAd() {
        interstitialAd = AdSurgeInterstitialAd(adUnitIdentifier: self.unitId ?? "10857")
        interstitialAd.delegate = self
        let adConfig = AdSurgeAdConfig(adFormat: .interstitial)
        adConfig.mute = SettingManager.shared.isMuted
        interstitialAd.load(adConfig)
    }
    
    override func showBtnTapped(_ sender: UIButton) {
        super.showBtnTapped(sender)
        if !interstitialAd.isValid {
            addCell("Ad not valid")
            return
        }
        interstitialAd.show(fromRootViewController: self)
    }

    // MARK: - AdSurgeInterstitialAdDelegate

    func didLoad(_ ad: AdSurgeAd) {
        print(#function)
        print("ad's format: \(ad.format.label), adUnitIdentifier: \(ad.adUnitIdentifier), revenue: \(ad.revenue)")
        addCell(#function)
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: AdSurgeError) {
        print(#function)
        print("ad's adUnitIdentifier: \(adUnitIdentifier), error: \(error)")
        addCell(#function)
    }

    func didDisplay(_ ad: AdSurgeAd, withError error: AdSurgeError?) {
        print(#function)
        print("\(String(describing: error))")
        addCell(#function)
    }

    func didHide(_ ad: AdSurgeAd) {
        print(#function)
        addCell(#function)
    }

    func didClick(_ ad: AdSurgeAd) {
        print(#function)
        addCell(#function)
    }

    func didPayRevenue(for ad: AdSurgeAd) {
        print(#function)
        addCell(#function)
    }
}
