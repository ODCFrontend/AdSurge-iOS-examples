//
//  AppOpenViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by shirao on 2026/1/8.
//

import UIKit
import AdSurgeSDK

class AppOpenViewController: BaseAdViewController, AdSurgeAppOpenAdDelegate {

    var appOpenAd: AdSurgeAppOpenAd!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.unitIds = ["16762", "16763"]
        self.unitIdTitles = ["General 16762", "Bidding 16763"]
        self.unitId = self.unitIds.first
    }

    override func setNavigationBar() {
        super.setNavigationBar()
        let label = UILabel()
        label.text = "AppOpenAD"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        self.navigationItem.titleView = label
    }

    override func loadAd() {
        guard let unitId = self.unitId else { return }
        self.appOpenAd = AdSurgeAppOpenAd(adUnitIdentifier: unitId)
        self.appOpenAd.delegate = self
        let adConfig = AdSurgeAdConfig(adFormat: .appOpen)
        self.appOpenAd.load(adConfig)
    }

    override func showBtnTapped(_ sender: UIButton) {
        super.showBtnTapped(sender)
        if (!self.appOpenAd.isValid) {
            addCell("Ad not valid")
            return
        }
        self.appOpenAd.show(fromRootViewController: self)
    }

    // MARK: - AdSurgeAppOpenAdDelegate

    func didLoad(_ ad: AdSurgeAd) {
        print(#function)
        print("ad's format: \(ad.format.label), adUnitIdentifier: \(ad.adUnitIdentifier), revenue: \(ad.revenue), creative_id: \(ad.creativeId)")
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
