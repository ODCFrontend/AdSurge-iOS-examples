//
//  RewardedViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by katie on 2025/6/5.
//

import Foundation
import UIKit
import AdSurgeSDK

class RewardedViewController: BaseAdViewController, AdSurgeRewardedAdDelegate {

    var rewardedAd: AdSurgeRewardedAd!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitIdTitles = [
            "General 10856",
        ];
        self.unitIds = [
            "10856",
        ]
        self.unitId = unitIds.first
    }

    override func setNavigationBar() {
        let label = UILabel()
        label.text = "RewardAD"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        self.navigationItem.titleView = label
    }

    override func loadAd() {
        rewardedAd = AdSurgeRewardedAd(adUnitIdentifier: self.unitId ?? "10856")
        rewardedAd?.delegate = self

        let adConfig = AdSurgeAdConfig(adFormat: .rewarded)
        adConfig.mute = SettingManager.shared.isMuted
        rewardedAd.load(adConfig)
    }
    
    override func showBtnTapped(_ sender: UIButton) {
        super.showBtnTapped(sender)
        if (!rewardedAd.isValid) {
            addCell("Ad not valid")
            return
        }
        rewardedAd.show(fromRootViewController: self)
    }

    // MARK: - AdSurgeRewardedAdDelegate

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

    func didRewardUser(for ad: AdSurgeAd, with reward: AdSurgeReward) {
        print(#function)
        addCell(#function)
    }

    func didPayRevenue(for ad: AdSurgeAd) {
        print(#function)
        addCell(#function)
    }
}
