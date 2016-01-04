# BottomSheet

Component which presents a dismissible view from the bottom of the screen

[![Cocoapods Compatible](http://img.shields.io/cocoapods/v/PCLBlurEffectAlert.svg?style=flat)](http://cocoadocs.org/docsets/PCLBlurEffectAlert)
[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

<img src="https://github.com/hryk224/Bottomsheet/wiki/images/sample1.gif" width="320" > <img src="https://github.com/hryk224/Bottomsheet/wiki/images/sample2.gif" width="320" > <img src="https://github.com/hryk224/Bottomsheet/wiki/images/sample3.gif" width="320" > <img src="https://github.com/hryk224/Bottomsheet/wiki/images/sample4.gif" width="320" >

## Requirements
- iOS 8.0+
- Swift 2.0+
- ARC

## install

#### Cocoapods

Adding the following to your `Podfile` and running `pod install`:

```Ruby
use_frameworks!
pod "Bottomsheet"
```

### import

```Swift
import Bottomsheet
```

## Usage

```Swift
let controller = Bottomsheet.Controller()

// Adds Toolbar
controller.addToolbar({ toolbar in
    // toolbar
})

// Adds View
let view = UIView
controller.addContentsView(view)

// Adds NavigationBar
controller.addNavigationbar(configurationHandler: { navigationBar in
    // navigationBar
})

// Adds CollectionView
controller.addCollectionView(configurationHandler: { [weak self] collectionView in
    // collectionView
})

// Adds TableView
controller.addTableView(configurationHandler: { [weak self] tableView in
    // tableView
})

// customize
controller.overlayBackgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
controller.viewActionType = .TappedDismiss
controller.initializeHeight = 200
```

## Acknowledgements

* Inspired by [Flipboard/bottomsheet](https://github.com/Flipboard/bottomsheet) in [Flipboard](https://github.com/Flipboard).

##License

This project is made available under the MIT license. See LICENSE file for details.
