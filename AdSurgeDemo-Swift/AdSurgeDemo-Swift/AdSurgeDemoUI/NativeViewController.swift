//
//  NativeViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by kaze on 2025/11/7.
//

import Foundation
import UIKit
import AdSurgeSDK

enum TableViewSection: Int {
    case sample = 1
    case ad = 2
    case count = 3
}

class NativeViewController: BaseAdViewController, AdSurgeNativeAdDelegate, AdSurgeNativeMediaContentDelegate {
    
    // MARK: - Properties
    
    private var infoTableView: UITableView!
    private var sampleDataArray: [[String: Any]] = []
    private var playButton: UIButton!
    private var pauseButton: UIButton!
    
    private var nativeAd: AdSurgeNativeAd?
    private var nativeAdView: AdSurgeNativeAdView?
    
    private var headLineLabel: UILabel?
    private var bodyLabel: UILabel?
    private var iconView: UIImageView?
    private var callToActionView: UILabel?
    private var mediaView: UIView?
    private var adChoicesView: UIView?
    private var mediaContent: AdSurgeMediaContent?
    private var hasRegisteredInteraction: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeShowButton()
        let unitIds = ["15839", "15839"]
        let titles = ["Image 15839", "Video 15839"]
        
        self.unitIds = unitIds
        self.unitIdTitles = titles
        self.unitId = unitIds.first
        
        initializeSampleData()
        setupInfoTableView()
    }
    
    deinit {
        print("NativeViewController dealloc")
    }
    
    // MARK: - TableView Setup
    
    private func setupInfoTableView() {
        infoTableView = UITableView(frame: .zero, style: .plain)
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        infoTableView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1.0)
        infoTableView.separatorStyle = .none
        infoTableView.rowHeight = UITableView.automaticDimension
        infoTableView.estimatedRowHeight = 400.0
        view.addSubview(infoTableView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            infoTableView.topAnchor.constraint(equalTo: guide.topAnchor),
            infoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SampleCell")
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdCell")
    }
    
    // MARK: - Navigation Bar
    
    internal override func setNavigationBar() {
        let label = UILabel()
        label.text = "NativeAd"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        navigationItem.titleView = label
    }
    
    // MARK: - Ad Loading
    
    override func loadAd() {
        if isBeingDismissed || isMovingFromParent {
            return
        }
        
        nativeAd = nil
        
        if let adView = nativeAdView {
            adView.removeFromSuperview()
            nativeAdView = nil
        }
        
        hasRegisteredInteraction = false
        
        guard let unitId = unitId else { return }
        
        let nativeAd = AdSurgeNativeAd(adUnitIdentifier: unitId)
        nativeAd.viewController = self
        nativeAd.delegate = self
        self.nativeAd = nativeAd
        
        let nativeAdView = AdSurgeNativeAdView()
        self.nativeAdView = nativeAdView
        
        let adConfig = AdSurgeAdConfig(adFormat: AdSurgeAdFormat.native)
        adConfig.nativeAdLogoPos = AdSurgeNativeAdLogoPosition.logoPosition_TopRight
        nativeAd.load(adConfig)
    }
    
    // MARK: - Common Init
    
    private func commonInit() {
        guard let nativeAd = nativeAd,
              let nativeAdView = nativeAdView else { return }
        
        // Icon View
        let iconImageView = UIImageView(image: nil)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 8.0
        iconImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        if let iconUrl = URL(string: nativeAd.iconInfo.iconUrl) {
            downloadImage(from: iconUrl) { image in
                iconImageView.image = image
            }
        }
        
        iconView = iconImageView
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Headline Label
        let headLineLabel = UILabel()
        headLineLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        headLineLabel.numberOfLines = 1
        headLineLabel.translatesAutoresizingMaskIntoConstraints = false
        headLineLabel.text = nativeAd.headLine
        self.headLineLabel = headLineLabel
        
        // Body Label
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        bodyLabel.numberOfLines = 2
        bodyLabel.textColor = .gray
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.text = nativeAd.body
        self.bodyLabel = bodyLabel
        
        // Media View
        let mediaView = UIView()
        mediaView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        mediaView.layer.cornerRadius = 8.0
        mediaView.clipsToBounds = true
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        self.mediaView = mediaView
        
        // Call to Action View
        let callToActionView = UILabel()
        callToActionView.backgroundColor = .systemBlue
        callToActionView.layer.cornerRadius = 6.0
        callToActionView.clipsToBounds = true
        callToActionView.textAlignment = .center
        callToActionView.text = nativeAd.callToAction
        callToActionView.textColor = .white
        callToActionView.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        callToActionView.translatesAutoresizingMaskIntoConstraints = false
        self.callToActionView = callToActionView
        
        // Ad Choices View
        adChoicesView = nativeAd.adChoicesView
        adChoicesView?.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        adChoicesView?.layer.cornerRadius = 6.0
        adChoicesView?.translatesAutoresizingMaskIntoConstraints = false
        
        // Play Button
        let playButton = UIButton()
        playButton.backgroundColor = .systemGreen
        playButton.layer.cornerRadius = 6.0
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("▶ Play", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        self.playButton = playButton
        
        // Pause Button
        let pauseButton = UIButton()
        pauseButton.backgroundColor = .systemOrange
        pauseButton.layer.cornerRadius = 6.0
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.setTitle("⏸ Pause", for: .normal)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(_:)), for: .touchUpInside)
        self.pauseButton = pauseButton
        
        // Add subviews
        nativeAdView.addSubview(iconImageView)
        nativeAdView.addSubview(headLineLabel)
        nativeAdView.addSubview(bodyLabel)
        nativeAdView.addSubview(mediaView)
        nativeAdView.addSubview(callToActionView)
        nativeAdView.addSubview(playButton)
        nativeAdView.addSubview(pauseButton)
        if let adChoicesView = adChoicesView {
            nativeAdView.addSubview(adChoicesView)
        }
        
        // Set views
        nativeAdView.setHeadline(_:headLineLabel)
        nativeAdView.setIcon(iconImageView)
        nativeAdView.setBody(bodyLabel)
        nativeAdView.setMedia(mediaView)
        nativeAdView.setCallToAction(callToActionView)
        
        nativeAdView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        
        mediaContent = nativeAd.mediaContent
        mediaContent?.delegate = self
        
        if let m = mediaContent {
            print("mediaContent ratio: \(m.aspectRatio())")
            print("mediaContent duration: \(m.duration())")
        } else {
            print("mediaContent ratio: 0.0")
            print("mediaContent duration: 0.0")
        }
        
        setupConstraints()
        infoTableView.reloadData()
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        guard let nativeAdView = nativeAdView,
              let iconView = iconView,
              let headLineLabel = headLineLabel,
              let bodyLabel = bodyLabel,
              let mediaView = mediaView,
              let callToActionView = callToActionView,
              let playButton = playButton,
              let pauseButton = pauseButton,
              let adChoicesView = adChoicesView else { return }
        
        let margin: CGFloat = 12.0
        let iconSize: CGFloat = 60.0
        let labelHeight: CGFloat = 30.0
        let buttonHeight: CGFloat = 36.0
        let buttonWidth: CGFloat = 75.0
        let buttonSpacing: CGFloat = 8.0
        let adChoicesWidth: CGFloat = 40.0
        
        // Icon View
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: margin),
            iconView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: margin),
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
        
        // Headline Label
        NSLayoutConstraint.activate([
            headLineLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            headLineLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10.0),
            headLineLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -margin),
            headLineLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        // Body Label
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: headLineLabel.bottomAnchor, constant: 6.0),
            bodyLabel.leadingAnchor.constraint(equalTo: headLineLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: headLineLabel.trailingAnchor),
            bodyLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        // Media View
        let mediaTopToIcon = mediaView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12.0)
        mediaTopToIcon.priority = .defaultLow
        mediaTopToIcon.isActive = true
        
        let mediaTopToBody = mediaView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12.0)
        mediaTopToBody.priority = .required
        mediaTopToBody.isActive = true
        
        NSLayoutConstraint.activate([
            mediaView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: margin),
            mediaView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -margin),
            mediaView.heightAnchor.constraint(equalToConstant: 300.0)
        ])
        
        // Ad Choices View
        NSLayoutConstraint.activate([
            adChoicesView.centerYAnchor.constraint(equalTo: callToActionView.centerYAnchor),
            adChoicesView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -12.0),
            adChoicesView.heightAnchor.constraint(equalToConstant: 24.0),
            adChoicesView.widthAnchor.constraint(equalToConstant: 40.0)
        ])
        
        // Call to Action View
        NSLayoutConstraint.activate([
            callToActionView.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10.0),
            callToActionView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: margin),
            callToActionView.heightAnchor.constraint(equalToConstant: buttonHeight),
            callToActionView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            callToActionView.bottomAnchor.constraint(lessThanOrEqualTo: nativeAdView.bottomAnchor, constant: -margin)
        ])
        
        // Play Button
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: callToActionView.topAnchor),
            playButton.leadingAnchor.constraint(equalTo: callToActionView.trailingAnchor, constant: buttonSpacing),
            playButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            playButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        // Pause Button
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: callToActionView.topAnchor),
            pauseButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: buttonSpacing),
            pauseButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            pauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            pauseButton.trailingAnchor.constraint(lessThanOrEqualTo: nativeAdView.trailingAnchor, constant: -(margin + adChoicesWidth + buttonSpacing))
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        guard let mediaContent = nativeAd?.mediaContent else {
            print("mediaContent is nil")
            return
        }
        mediaContent.play()
    }
    
    @objc private func pauseButtonTapped(_ sender: UIButton) {
        guard let mediaContent = nativeAd?.mediaContent else {
            print("Warning: mediaContent is nil")
            return
        }
        mediaContent.pause()
    }
    
    // MARK: - Image Download
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var image: UIImage?
            if let data = data, error == nil {
                image = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
    // MARK: - Sample Data Management
    
    private func initializeSampleData() {
        sampleDataArray = [
            [
                "title": "sample 1",
                "description": "This is the first sample cell, used for displaying content",
                "color": UIColor.systemBlue
            ],
            [
                "title": "sample 2",
                "description": "This is the second sample cell, showing different content",
                "color": UIColor.systemGreen
            ],
            [
                "title": "sample 3",
                "description": "This is the third sample cell. Let's continue to show",
                "color": UIColor.systemOrange
            ],
            [
                "title": "sample 4",
                "description": "This is the fourth sample cell, the last example",
                "color": UIColor.systemPurple
            ]
        ]
    }
    
    func addSampleCell(title: String, description: String, color: UIColor) {
        sampleDataArray.append([
            "title": title,
            "description": description,
            "color": color
        ])
        infoTableView.reloadSections(IndexSet(integer: TableViewSection.sample.rawValue), with: .automatic)
    }
    
    func removeSampleCell(at index: Int) {
        guard index >= 0 && index < sampleDataArray.count else { return }
        sampleDataArray.remove(at: index)
        infoTableView.reloadSections(IndexSet(integer: TableViewSection.sample.rawValue), with: .automatic)
    }
    
    func clearAllSampleCells() {
        sampleDataArray = []
        infoTableView.reloadSections(IndexSet(integer: TableViewSection.sample.rawValue), with: .automatic)
    }
    
    
    // MARK: - UITableViewDataSource
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard tableView === infoTableView else {
            return super.tableView(tableView, numberOfRowsInSection: 0)
        }
        return TableViewSection.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView === infoTableView else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        guard let sectionType = TableViewSection(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .sample:
            return sampleDataArray.count
        case .ad:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === infoTableView else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        guard let sectionType = TableViewSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case .sample:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
            cell.backgroundColor = .white
            
            // Remove previous subviews
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let sampleData = sampleDataArray[indexPath.row]
            configureSampleCell(cell, with: sampleData)
            return cell
            
        case .ad:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath)
            cell.backgroundColor = .white
            
            // Remove previous subviews
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            configureAdCell(cell)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    // MARK: - Cell Configuration
    
    private func configureSampleCell(_ cell: UITableViewCell, with sampleData: [String: Any]) {
        let title = sampleData["title"] as? String ?? ""
        let description = sampleData["description"] as? String ?? ""
        let color = sampleData["color"] as? UIColor ?? .systemBlue
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .gray
        descLabel.numberOfLines = 2
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(descLabel)
        
        let sampleView = UIView()
        sampleView.backgroundColor = color
        sampleView.layer.cornerRadius = 8.0
        sampleView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(sampleView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            
            descLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant:-16),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            
            sampleView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            sampleView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant:-16),
            sampleView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            sampleView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureAdCell(_ cell: UITableViewCell) {
        guard let nativeAdView = nativeAdView else { return }
        
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(nativeAdView)
        
        NSLayoutConstraint.activate([
            nativeAdView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            nativeAdView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant:12),
            nativeAdView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant:-12),
            nativeAdView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12)
        ])
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == TableViewSection.ad.rawValue {
            handleAdCellWillDisplay(cell, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = TableViewSection(rawValue: indexPath.section) else {
            return 44.0
        }
        
        switch sectionType {
        case .sample:
            return 180.0
        case .ad:
            return 480.0
        default:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    // MARK: - Ad Cell Display Handling
    
    func handleAdCellWillDisplay(_ cell: UITableViewCell, at indexPath: IndexPath) {
        if hasRegisteredInteraction {
            print("[Register] Already registered, skipping")
            return
        }
        
        guard let nativeAd = nativeAd, let nativeAdView = nativeAdView else {
            print("[Register] Missing nativeAd or nativeAdView")
            return
        }
        
        if isBeingDismissed || isMovingFromParent {
            print("[Register] View controller is deallocating")
            return
        }
        
        guard let headLineLabel = headLineLabel,
              let iconView = iconView,
              let callToActionView = callToActionView,
              let adChoicesView = adChoicesView else {
            print("[Register] Views not ready yet, ad might still be loading")
            return
        }
        
        nativeAd.registerView(forInteraction: nativeAdView, click: [headLineLabel, adChoicesView, iconView, callToActionView])
        hasRegisteredInteraction = true
    }
    
    
    // MARK: - AdSurgeNativeAdDelegate
    
    
    
    func didLoad(_ ad: AdSurgeAd) {
        print(#function)
        print("ad's format: \(ad.format.label), adUnitIdentifier: \(ad.adUnitIdentifier), revenue: \(ad.revenue)")
        commonInit()
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: AdSurgeError) {
        print(#function)
        print("ad's adUnitIdentifier: \(adUnitIdentifier), error: \(error)")
    }
    
    func didDisplay(_ ad: AdSurgeAd, withError error: AdSurgeError?) {
        print(#function)
        if let error = error {
            print(error)
        }
    }
    
    func didClick(_ ad: AdSurgeAd) {
        print(#function)
    }
    
    func didPayRevenue(for ad: AdSurgeAd) {
        print(#function)
    }
    
    
    // MARK: - AdSurgeNativeMediaContentDelegate
    
    
    
    func mediaContentDidStopVideo() {
        print(#function)
    }
    
    func mediaContentDidPauseVideo() {
        print(#function)
    }
    
    func mediaContentDidStartVideo() {
        print(#function)
    }
    
    
}
