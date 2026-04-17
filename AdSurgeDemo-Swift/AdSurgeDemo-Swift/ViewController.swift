//
//  ViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by andrew taylor on 2025/3/18.
//

import UIKit
import AdSurgeSDK

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let kTableViewHeaderHeight: CGFloat = 54.0

    private var demoArray: [[String: [[String]]]] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "tableView_id"
        return tableView
    }()

    override func loadView() {
        super.loadView()
        let section1 = [
            ["RewardAD", "RewardedViewController"],
            ["interstitialAD", "InterstitialViewController"],
            ["BannerAD", "BannerViewController"],
            ["NativeAD", "NativeViewController"],
            ["AppOpenAD", "AppOpenViewController"],
        ]
        demoArray = [
            ["Supported ad form": section1]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        self.view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBar()
    }

    private func setNavigationBar() {
        let label = UILabel()
        label.text = "AdSurge demo - Swift"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        self.navigationItem.titleView = label

        let button = UIButton(type: .custom)
        button.setImage(getBtnIcon(), for: .normal)
        button.addTarget(self, action: #selector(pressMuteBtn(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 25),
            button.heightAnchor.constraint(equalToConstant: 25)
        ])
        let muteBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = muteBtn
    }

    @objc private func pressMuteBtn(_ btn: UIButton) {
        SettingManager.shared.isMuted.toggle()
        let image = getBtnIcon()
        btn.setImage(image, for: .normal)
    }

    private func getBtnIcon() -> UIImage? {
        return SettingManager.shared.isMuted ? UIImage(named: "mute_icon") : UIImage(named: "unmute_icon")
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return demoArray.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTableViewHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: kTableViewHeaderHeight))
        let label = UILabel(frame: CGRect(x: 18.0, y: 0, width: header.bounds.width - 18.0, height: kTableViewHeaderHeight))
        label.text = Array(demoArray[section].keys)[0]
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        header.addSubview(label)
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let values = Array(demoArray[section].values)[0]
        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let SimpleTableIdentifier = "SimpleTableIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier) ??
            UITableViewCell(style: .default, reuseIdentifier: SimpleTableIdentifier)
        cell.selectionStyle = .none
        let cellConfig = Array(demoArray[indexPath.section].values)[0]
        cell.textLabel?.text = cellConfig[indexPath.row][0]

        let img = UIImageView(frame: CGRect(x: 383, y: 15, width: 10, height: 14))
        img.image = UIImage(named: "showMoreBtn")
        img.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(img)
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 10),
            img.heightAnchor.constraint(equalToConstant: 14),
            img.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            img.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20)
        ])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellConfig = Array(demoArray[indexPath.section].values)[0]
        let className = cellConfig[indexPath.row][1]
        
        var moduleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        moduleName = moduleName.replacingOccurrences(of: "-", with: "_")
        let fullClassName = "\(moduleName).\(className)"
        
        if let vcClass = NSClassFromString(fullClassName) as? UIViewController.Type {
            let vc = vcClass.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

