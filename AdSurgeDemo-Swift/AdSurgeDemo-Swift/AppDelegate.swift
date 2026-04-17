//
//  AppDelegate.swift
//  AdSurgeDemo-Swift
//
//  Created by andrew taylor on 2025/3/18.
//

import UIKit
import AdSurgeSDK
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    ATTrackingManager.requestTrackingAuthorization { status in

                    }
                }
            }
        }

        let config = AdSurgeSDKConfig()
        config.appId = "10037"

        AdSurgeAdSdk.shared().initialize(with: config) { success, error in
            print("AdSurge initialize - \(success ? "success" : "fail") - \(String(describing: error))")
        }

        return true
    }
}
