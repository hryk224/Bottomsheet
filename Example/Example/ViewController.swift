//
//  ViewController.swift
//  Example
//
//  Created by hiroyuki yoshida on 2015/10/17.
//  Copyright © 2015年 hiroyuki yoshida. All rights reserved.
//

import UIKit
import Bottomsheet

private struct Assets {
    static let image00 = UIImage(named: "0")!
    static let image01 = UIImage(named: "1")!
    static let image02 = UIImage(named: "2")!
    static let image03 = UIImage(named: "3")!
    static let image04 = UIImage(named: "4")!
    static let image05 = UIImage(named: "5")!
    static let image06 = UIImage(named: "6")!
    static let image07 = UIImage(named: "7")!
    static let image08 = UIImage(named: "8")!
    static let image09 = UIImage(named: "9")!
    static var images: [UIImage] {
        let images = [Assets.image00, Assets.image01, Assets.image02, Assets.image03, Assets.image04, Assets.image05, Assets.image06, Assets.image07, Assets.image08, Assets.image09]
        return images
    }
}

class ViewController: UIViewController {
    fileprivate var delegateManager = DelegateManager()
    fileprivate var items = ["Simple", "CollectionView", "CollectionView 2 column", "TableView"]
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 60
            tableView.estimatedRowHeight = 60
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = Bottomsheet.Controller()
        if indexPath.row == 0 {
            let contentView = UIView()
            view.backgroundColor = .green
            let button = UIButton()
            button.frame.size = CGSize(width: 100, height: 40)
            button.center = contentView.center
            button.backgroundColor = .red
            button.setTitle("dismiss", for: .normal)
            button.addTarget(controller, action: #selector(Bottomsheet.Controller.dismiss(_:)), for: .touchUpInside)
            contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints([NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 100),
                                        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40),
                                        NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
                                        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)])
            controller.addContentsView(contentView)
        } else if indexPath.row == 1 {
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
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
                layout?.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20)
                layout?.minimumLineSpacing = 10
                layout?.minimumInteritemSpacing = 10
                layout?.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
            }
            controller.overlayBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        } else if indexPath.row == 2 {
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
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
                layout?.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
            }
            controller.viewActionType = .tappedDismiss
            controller.overlayBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        } else if indexPath.row == 3 {
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
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
            controller.initializeHeight = 200
        }
        present(controller, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

final class DelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    var items = Assets.images
    override init() {
        super.init()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellIdentifier) as! TableViewCell
        cell.newImageView.image = items[indexPath.row]
        cell.newTitleLabel.text = "\(indexPath.row)"
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.imageView.image = items[indexPath.row]
        return cell
    }
}

private class CollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CollectionViewCell"
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    fileprivate func configure() {
        contentView.addSubview(imageView)
    }
}

private class TableViewCell: UITableViewCell {
    static let cellIdentifier = "TableViewCell"
    lazy var newImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
        imageView.autoresizingMask = UIViewAutoresizing()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var newTitleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 110, y: 0, width: 200, height: 100))
        titleLabel.autoresizingMask = UIViewAutoresizing()
        titleLabel.clipsToBounds = true
        return titleLabel
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    fileprivate func configure() {
        contentView.addSubview(newImageView)
        contentView.addSubview(newTitleLabel)
        selectionStyle = .none
    }
}
