//
//  DelegateManager.swift
//  Example
//
//  Created by yoshida hiroyuki on 2017/02/22.
//  Copyright © 2017年 hiroyuki yoshida. All rights reserved.
//

import UIKit

final class DelegateManager: NSObject, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    let images = Assets.Image.share
    override init() {
        super.init()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellIdentifier) as! TableViewCell
        cell.newImageView.image = images.objects[indexPath.row]
        cell.newTitleLabel.text = "\(indexPath.row)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.imageView.image = images.objects[indexPath.row]
        return cell
    }
}
