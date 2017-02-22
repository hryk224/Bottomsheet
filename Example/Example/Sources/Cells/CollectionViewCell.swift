//
//  CollectionViewCell.swift
//  Example
//
//  Created by yoshida hiroyuki on 2017/02/22.
//  Copyright © 2017年 hiroyuki yoshida. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
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
