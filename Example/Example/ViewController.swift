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
    private var delegateManager = DelegateManager()
    private var items = ["Simple", "CollectionView", "CollectionView 2 column", "TableView"]
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 60
            tableView.estimatedRowHeight = 60
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = Bottomsheet.Controller()
        if indexPath.row == 0 {
            let contentView = UIView()
            view.backgroundColor = UIColor.greenColor()
            let button = UIButton()
            button.frame.size = CGSizeMake(100, 40)
            button.center = contentView.center
            button.backgroundColor = UIColor.redColor()
            button.setTitle("dismiss", forState: .Normal)
            button.addTarget(controller, action: #selector(Bottomsheet.Controller.dismiss(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints([NSLayoutConstraint(item: button,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .Width,
                multiplier: 1,
                constant: 100),
                NSLayoutConstraint(item: button,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .Height,
                    multiplier: 1,
                    constant: 40),
                NSLayoutConstraint(item: button,
                    attribute: .CenterX,
                    relatedBy: .Equal,
                    toItem: contentView,
                    attribute: .CenterX,
                    multiplier: 1,
                    constant: 0),
                NSLayoutConstraint(item: button,
                    attribute: .CenterY,
                    relatedBy: .Equal,
                    toItem: contentView,
                    attribute: .CenterY,
                    multiplier: 1,
                    constant: 0)])
            controller.addContentsView(contentView)
        } else if indexPath.row == 1 {
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .Plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .Plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
                item.leftBarButtonItem = leftButton
                navigationBar.items = [item]
            }
            controller.addCollectionView { [weak self] collectionView in
                collectionView.delegate = self?.delegateManager
                collectionView.dataSource = self?.delegateManager
                collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
                collectionView.backgroundColor = UIColor.whiteColor()
                collectionView.contentInset.top = 64
                collectionView.scrollIndicatorInsets.top = 64
                let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                layout?.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, UIScreen.mainScreen().bounds.width - 20)
                layout?.minimumLineSpacing = 10
                layout?.minimumInteritemSpacing = 10
                layout?.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
            }
            controller.overlayBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        } else if indexPath.row == 2 {
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .Plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .Plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
                item.leftBarButtonItem = leftButton
                navigationBar.items = [item]
            }
            controller.addCollectionView { [weak self] collectionView in
                collectionView.delegate = self?.delegateManager
                collectionView.dataSource = self?.delegateManager
                collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
                collectionView.backgroundColor = UIColor.whiteColor()
                collectionView.contentInset.top = 64
                collectionView.scrollIndicatorInsets.top = 64
                let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                let width = (UIScreen.mainScreen().bounds.width - 30) / 2
                layout?.itemSize = CGSizeMake(width, width)
                layout?.minimumLineSpacing = 10
                layout?.minimumInteritemSpacing = 10
                layout?.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
            }
            controller.viewActionType = .TappedDismiss
            controller.overlayBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        } else if indexPath.row == 3 {
            controller.addNavigationbar { navigationBar in
                let item = UINavigationItem(title: "title")
                let rightButton = UIBarButtonItem(title: "dismiss", style: .Plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                item.rightBarButtonItem = rightButton
                let leftButton = UIBarButtonItem(title: "present", style: .Plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
                item.leftBarButtonItem = leftButton
                navigationBar.items = [item]
            }
            controller.addTableView { [weak self] tableView in
                tableView.delegate = self?.delegateManager
                tableView.dataSource = self?.delegateManager
                tableView.rowHeight = 100
                tableView.estimatedRowHeight = 100
                tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellIdentifier)
                tableView.contentInset.top = 64
                tableView.scrollIndicatorInsets.top = 64
            }
            controller.viewActionType = .TappedDismiss
            controller.initializeHeight = 200
        }
        presentViewController(controller, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

final class DelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    var items = Assets.images
    override init() {
        super.init()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.cellIdentifier) as! TableViewCell
        cell.newImageView.image = items[indexPath.row]
        cell.newTitleLabel.text = "\(indexPath.row)"
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCell.cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView.image = items[indexPath.row]
        return cell
    }
}

private class CollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CollectionViewCell"
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.FlexibleTopMargin, .FlexibleRightMargin, .FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleWidth, .FlexibleHeight]
        imageView.contentMode = .ScaleAspectFill
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
    private func configure() {
        contentView.addSubview(imageView)
    }
}

private class TableViewCell: UITableViewCell {
    static let cellIdentifier = "TableViewCell"
    lazy var newImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
        imageView.autoresizingMask = .None
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var newTitleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 110, y: 0, width: 200, height: 100))
        titleLabel.autoresizingMask = .None
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
    private func configure() {
        contentView.addSubview(newImageView)
        contentView.addSubview(newTitleLabel)
        selectionStyle = .None
    }
}