//
//  ViewController.swift
//  Example
//
//  Created by hiroyuki yoshida on 2015/10/17.
//  Copyright © 2015年 hiroyuki yoshida. All rights reserved.
//

import UIKit
import Bottomsheet

class ViewController: UIViewController {
    private var delegateManager = DelegateManager()
    private var items = ["Simple", "Toolbar + CollectionView", "Navigationbar + TableView(200pt)"]
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
            controller.addToolbar({ toolbar in
                let button01 = UIBarButtonItem(title: "present", style:.Plain, target: controller, action: #selector(Bottomsheet.Controller.present(_:)))
                let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
                let button02 = UIBarButtonItem(title: "dismiss", style:.Plain, target: controller, action: #selector(Bottomsheet.Controller.dismiss(_:)))
                toolbar.items = [button01, spacer, button02]
            })
            controller.addCollectionView { [weak self] collectionView in
                collectionView.delegate = self?.delegateManager
                collectionView.dataSource = self?.delegateManager
                collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
                collectionView.backgroundColor = UIColor.whiteColor()
                collectionView.contentInset.top = 44
                collectionView.scrollIndicatorInsets.top = 44
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
            controller.addTableView { [weak self] tableView in
                tableView.delegate = self?.delegateManager
                tableView.dataSource = self?.delegateManager
                tableView.rowHeight = 100
                tableView.estimatedRowHeight = 100
                tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
}
