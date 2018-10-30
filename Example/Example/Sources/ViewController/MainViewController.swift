//
//  MainViewController.swift
//  Example
//
//  Created by hiroyuki yoshida on 2015/10/17.
//  Copyright © 2015年 hiroyuki yoshida. All rights reserved.
//

import UIKit
import Bottomsheet

final class MainViewController: UIViewController {
    enum Row: Int, CustomStringConvertible {
        case view
        case collectionView
        case collectionViewIsScrollDisabledInSheet
        case tableView
        case tableViewToolbar
        static var count: Int {
            return 5
        }
        var description: String {
            switch self {
            case .view: return "View"
            case .collectionView: return "CollectionView + Navigation"
            case .collectionViewIsScrollDisabledInSheet: return "CollectionView + Navigation (scroll disabled in sheet)"
            case .tableView: return "TableView"
            case .tableViewToolbar: return "TableView + Toolbar"
            }
        }
    }
    let identifier = "MainCell"
    var cellHeight: CGFloat {
        return max(100, (UIScreen.main.bounds.height - 64) / CGFloat(Row.count))
    }
    fileprivate var delegateManager = DelegateManager()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = cellHeight
            tableView.estimatedRowHeight = cellHeight
            tableView.separatorInset = .zero
            tableView.layoutMargins = .zero
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        let row = Row(rawValue: indexPath.row)
        cell.textLabel?.text = row?.description
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else { return }
        let controller = BottomsheetController()
        switch row {
        case .view:
            let contentView = UIView()
            let button = UIButton()
            button.frame.size = CGSize(width: 100, height: 40)
            button.center = contentView.center
            button.backgroundColor = .red
            button.setTitle("dismiss", for: .normal)
            button.addTarget(controller, action: #selector(BottomsheetController.dismiss(_:)), for: .touchUpInside)
            contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints([NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 100),
                                        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40),
                                        NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
                                        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)])
            controller.viewActionType = .tappedPresent
            controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
            controller.addContentsView(contentView)
        case .collectionView:
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(BottomsheetController.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(BottomsheetController.present(_:)))
                item.leftBarButtonItem = leftButton
                navigationBar.items = [item]
            }
            controller.addCollectionView { [weak self] collectionView in
                collectionView.delegate = self?.delegateManager
                collectionView.dataSource = self?.delegateManager
                collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
                collectionView.backgroundColor = .white
                collectionView.contentInset.top = 64
                collectionView.scrollIndicatorInsets.top = 64
                let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                let width = (UIScreen.main.bounds.width - 30) / 2
                layout?.itemSize = CGSize(width: width, height: width)
                layout?.minimumLineSpacing = 10
                layout?.minimumInteritemSpacing = 10
                layout?.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
            controller.viewActionType = .tappedDismiss
            controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
            controller.initializeHeight = UIScreen.main.bounds.height / 2
        case .collectionViewIsScrollDisabledInSheet:
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(BottomsheetController.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(BottomsheetController.present(_:)))
                item.leftBarButtonItem = leftButton
                navigationBar.items = [item]
            }
            controller.addCollectionView(isScrollEnabledInSheet: false) { [weak self] collectionView in
                collectionView.delegate = self?.delegateManager
                collectionView.dataSource = self?.delegateManager
                collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
                collectionView.backgroundColor = .white
                collectionView.contentInset.top = 64
                collectionView.scrollIndicatorInsets.top = 64
                let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                let width = (UIScreen.main.bounds.width - 30) / 2
                layout?.itemSize = CGSize(width: width, height: width)
                layout?.minimumLineSpacing = 10
                layout?.minimumInteritemSpacing = 10
                layout?.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
            controller.viewActionType = .swipe
            controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
            controller.initializeHeight = UIScreen.main.bounds.height / 2
        case .tableView:
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(BottomsheetController.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(BottomsheetController.present(_:)))
                item.leftBarButtonItem = leftButton
                navigationBar.items = [item]
            }
            controller.addTableView { [weak self] tableView in
                tableView.delegate = self?.delegateManager
                tableView.dataSource = self?.delegateManager
                tableView.rowHeight = 100
                tableView.estimatedRowHeight = 100
                tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellIdentifier)
                tableView.contentInset.top = 64
                tableView.scrollIndicatorInsets.top = 64
            }
            controller.viewActionType = .tappedDismiss
            controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
            controller.initializeHeight = 200
        case .tableViewToolbar:
            controller.addToolbar { toolbar in
                let dismiss = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(BottomsheetController.dismiss(_:)))
                let present = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(BottomsheetController.present(_:)))
                toolbar.items = [dismiss, present]
            }
            controller.addTableView { [weak self] tableView in
                tableView.delegate = self?.delegateManager
                tableView.dataSource = self?.delegateManager
                tableView.rowHeight = 100
                tableView.estimatedRowHeight = 100
                tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellIdentifier)
                tableView.contentInset.top = 64
                tableView.scrollIndicatorInsets.top = 64
            }
            controller.viewActionType = .swipe
            controller.overlayBackgroundColor = UIColor.red.withAlphaComponent(0.6)
            controller.initializeHeight = UIScreen.main.bounds.height / 2
        }
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}
