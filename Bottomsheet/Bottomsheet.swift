//
//  Bottomsheet.swift
//  Pods
//
//  Created by hiroyuki yoshida on 2015/10/17.
//
//

import UIKit

public class Bottomsheet {
    public class Controller: UIViewController {
        public enum OverlayViewActionType: Int {
            case Swipe, TappedDismiss
        }
        // public
        public var overlayBackgroundColor: UIColor? {
            set {
                overlayView.backgroundColor = newValue
            }
            get {
                return overlayView.backgroundColor
            }
        }
        public var initializeHeight: CGFloat = 300 {
            didSet {
                containerViewHeightConstraint.constant = initializeHeight
            }
        }
        public var maxHeight: CGFloat = UIScreen.mainScreen().bounds.height
        public var downRange: CGFloat = 100
        public var upRange: CGFloat = 50
        public var viewActionType: Bottomsheet.Controller.OverlayViewActionType = .Swipe
        // OverlayView
        public let overlayView = UIView()
        // ContainerView
        public let containerView = UIView()
        public var containerViewBackgroundColor = UIColor(white: 1, alpha: 1)
        public var containerViewHeightConstraint: NSLayoutConstraint!
        // private
        private var isNeedlayout = true
        private var toolbar: UIToolbar?
        private var navigationBar: NavigationBar?
        private var overlayViewPanGestureRecognizer = UIPanGestureRecognizer()
        private var overlayViewTapGestureRecognizer = UITapGestureRecognizer()
        private var panGestureRecognizer = UIPanGestureRecognizer()
        private var finishedPanGestureRecognizer = UIPanGestureRecognizer()
        private var contentView: UIView?
        private var scrollView: UIScrollView?
        private var hasView: Bool {
            var bool = false
            if let _ = contentView {
                bool = true
            } else if let _ = scrollView {
                bool = true
            }
            return bool
        }
        private var isDismissing = false
        public convenience init() {
            self.init(nibName: nil, bundle: nil)
            configure()
            configureConstraints()
        }
        // Adds UIToolbar
        public func addToolbar(configurationHandler: ((UIToolbar) -> Void)? = nil) {
            if let _ = self.toolbar {
                fatalError("UIToolbar or UINavigationBar can only have one")
            } else if let _ = self.navigationBar {
                fatalError("UIToolbar or UINavigationBar can only have one")
            }
            let toolbar = UIToolbar()
            containerView.addSubview(toolbar)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            let toolbarTopConstraint = NSLayoutConstraint(item: toolbar, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let toolbarRightConstraint = NSLayoutConstraint(item: toolbar, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let toolbarLeftConstraint = NSLayoutConstraint(item: toolbar, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            containerView.addConstraints([toolbarTopConstraint, toolbarRightConstraint, toolbarLeftConstraint])
            toolbar.addGestureRecognizer(panGestureRecognizer)
            panGestureRecognizer.delegate = self
            panGestureRecognizer.addTarget(self, action: "handleGestureDragging:")
            configurationHandler?(toolbar)
            self.toolbar = toolbar
        }
        // Adds UINavigationbar
        public func addNavigationbar(configurationHandler configurationHandler: ((UINavigationBar) -> Void)? = nil) {
            if let _ = self.toolbar {
                fatalError("UIToolbar or UINavigationBar can only have one")
            } else if let _ = self.navigationBar {
                fatalError("UIToolbar or UINavigationBar can only have one")
            }
            let naviBar = UINavigationBar()
            naviBar.sizeToFit()
            let navigationBar = NavigationBar()
            navigationBar.height = naviBar.frame.height
            containerView.addSubview(navigationBar)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            let navigationbarTopConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let navigationbarRightConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let navigationbarLeftConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            containerView.addConstraints([navigationbarTopConstraint, navigationbarRightConstraint, navigationbarLeftConstraint])
            navigationBar.addGestureRecognizer(panGestureRecognizer)
            panGestureRecognizer.delegate = self
            panGestureRecognizer.addTarget(self, action: "handleGestureDragging:")
            configurationHandler?(navigationBar)
            self.navigationBar = navigationBar
        }
        // Adds ContentsView
        public func addContentsView(contentView: UIView) {
            if hasView {
                fatalError("ContainerView can only have one")
            }
            containerView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            let mainViewTopConstraint = NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            contentView.addGestureRecognizer(panGestureRecognizer)
            panGestureRecognizer.delegate = self
            panGestureRecognizer.addTarget(self, action: "handleGestureDragging:")
            self.contentView = contentView
        }
        // Adds UIScrollView
        public func addScrollView(configurationHandler configurationHandler: ((UIScrollView) -> Void)) {
            if hasView {
                fatalError("ContainerView can only have one \(containerView.subviews)")
            }
            let scrollView = UIScrollView()
            containerView.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            configurationHandler(scrollView)
            let mainViewTopConstraint = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            self.scrollView = scrollView
        }
        // Adds UICollectionView
        public func addCollectionView(flowLayout: UICollectionViewFlowLayout? = nil, configurationHandler: ((UICollectionView) -> Void)) {
            if hasView {
                fatalError("ContainerView can only have one \(containerView.subviews)")
            }
            let collectionView: UICollectionView
            if let flowLayout = flowLayout {
                collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            } else {
                let flowLayout = UICollectionViewFlowLayout()
                collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            }
            containerView.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            configurationHandler(collectionView)
            let mainViewTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: collectionView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: collectionView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            collectionView.reloadData()
            self.scrollView = collectionView
        }
        // Adds UITableView
        public func addTableView(configurationHandler configurationHandler: ((UITableView) -> Void)) {
            if hasView {
                fatalError("ContainerView can only have one \(containerView.subviews)")
            }
            let tableView = UITableView(frame: CGRect.zero)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(tableView)
            configurationHandler(tableView)
            let mainViewTopConstraint = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            tableView.reloadData()
            self.scrollView = tableView
        }
        // Life cycle
        public override func viewDidLoad() {
            super.viewDidLoad()
            overlayView.backgroundColor = overlayBackgroundColor
            containerView.backgroundColor = containerViewBackgroundColor
            automaticallyAdjustsScrollViewInsets = false
        }
        public override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            adjustLayout()
        }
        public override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            overlayViewPanGestureRecognizer.removeTarget(self, action: "handleGestureDragging:")
            overlayViewTapGestureRecognizer.removeTarget(self, action: "handleTap:")
        }
        public func present(sender: AnyObject? = nil) {
            containerViewHeightConstraint.constant = maxHeight
            overlayViewPanGestureRecognizer.removeTarget(self, action: "handleGestureDragging:")
            panGestureRecognizer.removeTarget(self, action: "handleGestureDragging:")
            UIView.animateWithDuration(0.3) {
                self.view.layoutIfNeeded()
            }
        }
        public func dismiss(sender: AnyObject? = nil) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        dynamic func handleTap(gestureRecognizer: UITapGestureRecognizer) {
            dismiss()
        }
        dynamic func handleGestureDragging(gestureRecognizer: UIPanGestureRecognizer) {
            let point = gestureRecognizer.translationInView(gestureRecognizer.view)
            let originY = view.frame.height - initializeHeight
            switch gestureRecognizer.state {
            case .Began:
                break
            case .Changed:
                containerView.frame.origin.y += point.y
                containerViewHeightConstraint.constant = max(initializeHeight, UIScreen.mainScreen().bounds.height - containerView.frame.origin.y)
                gestureRecognizer.setTranslation(CGPointZero, inView: gestureRecognizer.view)
            case .Ended, .Cancelled:
                if containerView.frame.origin.y - originY > downRange {
                    dismiss()
                } else if containerViewHeightConstraint.constant - initializeHeight > upRange {
                    present()
                } else {
                    let animations = {
                        self.containerView.frame.origin.y = originY
                    }
                    UIView.performSystemAnimation(.Delete, onViews: [], options: [], animations: animations, completion: nil)
                }
            default:
                break
            }
            let rate = (containerView.frame.origin.y - (originY))  / (containerView.frame.height)
            overlayView.alpha = max(0, min(1, (1 - rate)))
        }
    }
}

// MARK: - private
private extension Bottomsheet.Controller {
    private func configure() {
        modalPresentationStyle = .OverCurrentContext
        transitioningDelegate = self
        view.frame.size = UIScreen.mainScreen().bounds.size
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        overlayView.frame = UIScreen.mainScreen().bounds
        view.addSubview(overlayView)
        view.addSubview(containerView)
    }
    private func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerViewHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: initializeHeight)
        let containerViewRightConstraint = NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0)
        let containerViewLeftConstraint = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0)
        let containerViewBottomLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraints([containerViewHeightConstraint, containerViewRightConstraint, containerViewLeftConstraint, containerViewBottomLayoutConstraint])
    }
    private func adjustLayout() {
        if !isNeedlayout {
            return
        }
        isNeedlayout = false
        if let toolbar = toolbar {
            containerView.bringSubviewToFront(toolbar)
        } else if let navigationBar = navigationBar {
            containerView.bringSubviewToFront(navigationBar)
        }
        switch viewActionType {
        case .Swipe:
            overlayViewPanGestureRecognizer.addTarget(self, action: "handleGestureDragging:")
            overlayViewPanGestureRecognizer.delegate = self
            overlayView.addGestureRecognizer(overlayViewPanGestureRecognizer)
        default:
            overlayViewTapGestureRecognizer.addTarget(self, action: "handleTap:")
            overlayView.addGestureRecognizer(overlayViewTapGestureRecognizer)
        }
        scrollView?.setContentOffset(CGPoint(x: 0, y: -(scrollView?.scrollIndicatorInsets.top ?? 0)), animated: false)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension Bottomsheet.Controller: UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, gestureRecognizerView = gestureRecognizer.view {
            let velocity = gestureRecognizer.translationInView(gestureRecognizerView)
            return fabs(velocity.y) > fabs(velocity.x)
        }
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension Bottomsheet.Controller: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Bottomsheet.TransitionAnimator(present: true)
    }
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Bottomsheet.TransitionAnimator(present: false)
    }
}

// MARK: - NavigationBar
extension Bottomsheet {
    public class NavigationBar: UINavigationBar {
        var height: CGFloat = 44
        public override func sizeThatFits(size: CGSize) -> CGSize {
            var barSize = super.sizeThatFits(size)
            barSize.height += UIApplication.sharedApplication().statusBarFrame.height
            return barSize
        }
        public override func layoutSubviews() {
            super.layoutSubviews()
            frame.size.height = height + UIApplication.sharedApplication().statusBarFrame.height
        }
    }
}

// MARK: - TransitionAnimator
extension Bottomsheet {
    public class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        private typealias TransitionAnimator = Bottomsheet.TransitionAnimator
        private static let presentBackAnimationDuration: NSTimeInterval = 0.6
        private static let dismissBackAnimationDuration: NSTimeInterval = 0.6
        private var goingPresent: Bool?
        init(present: Bool) {
            super.init()
            goingPresent = present
        }
        public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            if goingPresent == true {
                return TransitionAnimator.presentBackAnimationDuration
            } else {
                return TransitionAnimator.dismissBackAnimationDuration
            }
        }
        public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            if goingPresent == true {
                presentAnimation(transitionContext)
            } else {
                dismissAnimation(transitionContext)
            }
        }
        // private
        private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
            if let controller = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? Bottomsheet.Controller,
                containerView = transitionContext.containerView() {
                containerView.backgroundColor = UIColor.clearColor()
                containerView.addSubview(controller.view)
                controller.overlayView.alpha = 0
                controller.containerView.transform = CGAffineTransformMakeTranslation(0, controller.initializeHeight)
                let animations = {
                    controller.overlayView.alpha = 1
                    controller.containerView.transform = CGAffineTransformIdentity
                }
                let completion: ((Bool) -> ()) = { finished in
                    if finished {
                        let cancelled = transitionContext.transitionWasCancelled()
                        if cancelled {
                            controller.view.removeFromSuperview()
                        }
                        transitionContext.completeTransition(!cancelled)
                    }
                }
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: animations, completion: completion)
            } else {
                transitionContext.completeTransition(false)
            }
        }
        private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
            if let controller = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? Bottomsheet.Controller {
                if controller.containerViewHeightConstraint.constant != controller.initializeHeight {
                    controller.overlayView.removeFromSuperview()
                }
                let animations = {
                    controller.overlayView.alpha = 0
                    controller.containerView.transform = CGAffineTransformMakeTranslation(0, controller.containerViewHeightConstraint.constant)
                }
                let completion: ((Bool) -> ()) = { finished in
                    if finished {
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    }
                }
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: animations, completion: completion)
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}
