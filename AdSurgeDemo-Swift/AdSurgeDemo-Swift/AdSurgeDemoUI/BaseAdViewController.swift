//
//  BaseAdViewController.swift
//  AdSurgeDemo-Swift
//
//  Created by katie on 2025/6/5.
//

import Foundation

import UIKit

class BaseAdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private var flowArray: [String] = []
    private var showButton: UIButton?
    var unitIdTitles: [String] = []
    var unitIds: [String] = []
    var unitId: String? {
        didSet {
            loadAd()
        }
    }
    func loadAd() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 247/255.0, alpha: 1.0)
        self.view.backgroundColor = bgColor
        setNavigationBar()

        let showBtn = UIButton()
        showBtn.backgroundColor = .white
        showBtn.setTitle("Show", for: .normal)
        showBtn.setTitleColor(.blue, for: .normal)
        showBtn.addTarget(self, action: #selector(showBtnTapped(_:)), for: .touchUpInside)
        showBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(showBtn)
        
        let button = UIButton(type: .custom)
        button.setTitle("UnitId", for: .normal)
        button.addTarget(self, action: #selector(unitid(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        let btnItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = btnItem
        
        NSLayoutConstraint.activate([
            showBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            showBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            showBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            showBtn.heightAnchor.constraint(equalToConstant: 65)
        ])
        self.showButton = showBtn
        setupTableView()
    }
    
    @objc func unitid(_ sender: UIButton) {
        let alertController = UIAlertController(title: "UnitIdentifier", message: nil, preferredStyle: .actionSheet)
        for optionTitle in self.unitIdTitles {
            let action = UIAlertAction(title: optionTitle, style: .default) { [weak self] _ in
                if let index = self?.unitIdTitles.firstIndex(of: optionTitle) {
                    self?.unitId = self?.unitIds[index];
                }
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = self.view.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func showBtnTapped(_ sender: UIButton) {
        print("Show button was tapped!")
    }

    func addCell(_ text: String) {
        flowArray.append(text)
        tableView.reloadData()
    }

    func setNavigationBar() {

    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "tableView_id"
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flowArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SimpleTableIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = flowArray[indexPath.row]
        cell.backgroundColor = .white
        return cell
    }

    func setCornerRadiusForSectionCell(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        let cornerRadius: CGFloat = 10.0
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let bounds = cell.bounds
        let shapeLayer = CAShapeLayer()
        cell.layer.mask = nil

        if sectionCount > 1 {
            if indexPath.row == 0 {
                let path = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                shapeLayer.path = path.cgPath
                cell.layer.mask = shapeLayer
            } else if indexPath.row == sectionCount - 1 {
                let path = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                shapeLayer.path = path.cgPath
                cell.layer.mask = shapeLayer
            }
        } else {
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            shapeLayer.path = path.cgPath
            cell.layer.mask = shapeLayer
        }
    }
    func removeShowButton() {
        if let showBtn = showButton {
            showBtn.removeFromSuperview()
            self.showButton = nil
            print("Show button removed")
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                cell.backgroundColor = UIColor.systemFill
            } else {
                cell.backgroundColor = UIColor.white
            }
        } else {
            cell.backgroundColor = UIColor.white
        }
        setCornerRadiusForSectionCell(cell: cell, indexPath: indexPath, tableView: tableView)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.tableView.reloadData()
        }, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.tableView.reloadData()
    }
    
}
