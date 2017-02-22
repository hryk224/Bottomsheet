//
//  Assets.swift
//  Example
//
//  Created by yoshida hiroyuki on 2017/02/22.
//  Copyright © 2017年 hiroyuki yoshida. All rights reserved.
//

import UIKit.UIImage
import UIKit.UIColor

struct Assets {
    struct Image {
        static let share: Assets.Image = Image()
        let objects: [UIImage]
        private let countableRange: CountableRange<Int> = 0..<36
        var count: Int {
            return countableRange.count
        }
        private init() {
            objects = countableRange.map { String($0) }.flatMap { UIImage(named: $0) }
        }
    }
}
