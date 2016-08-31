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
        public enum OverlayViewActionType {
            case Swipe, TappedDismiss
        }
        // public
        public var initializeHeight: CGFloat = 300 {
            didSet {
                containerViewHeightConstraint?.constant = initializeHeight
            }
        }
        public var maxHeight: CGFloat = UIScreen.mainScreen().bounds.height
        public var viewActionType: Bottomsheet.Controller.OverlayViewActionType = .TappedDismiss
        public var moveRange: (down: CGFloat, up: CGFloat) = (150, 100)
        public var duration: (hide: NSTimeInterval, show: NSTimeInterval, showAll: NSTimeInterval) = (0.3, 0.3, 0.3)
        // OverlayView
        public let overlayView = UIView()
        public var overlayBackgroundColor: UIColor? {
            set { overlayView.backgroundColor = newValue }
            get { return overlayView.backgroundColor }
        }
        // ContainerView
        public let containerView = UIView()
        public var containerViewBackgroundColor = UIColor(white: 1, alpha: 1)
        // private
        private var containerViewHeightConstraint: NSLayoutConstraint?
        private enum State {
            case Hide
            case Show
            case ShowAll
        }
        private var state: State = .Hide {
            didSet {
                newState(state)
            }
        }
        private var isNeedLayout = true
        private var bar: UIView?
        // gesture
        private var overlayViewPanGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        private var overlayViewTapGestureRecognizer: UITapGestureRecognizer = {
            let gestureRecognizer = UITapGestureRecognizer()
            return gestureRecognizer
        }()
        private var panGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        private var barGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        //
        private var contentView: UIView?
        private var scrollView: UIScrollView?
        private var hasBar: Bool {
            if let _ = bar {
                return true
            }
            return false
        }
        private var hasView: Bool {
            if let _ = contentView {
                return true
            } else if let _ = scrollView {
                return true
            }
            return false
        }
        private var isDismissing = false
        public convenience init() {
            self.init(nibName: nil, bundle: nil)
            configure()
            configureConstraints()
        }
        // Adds UIToolbar
        public func addToolbar(configurationHandler: ((UIToolbar) -> Void)? = nil) {
            guard !hasBar else { fatalError("UIToolbar or UINavigationBar can only have one") }
            let toolbar = UIToolbar()
            containerView.addSubview(toolbar)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            let toolbarTopConstraint = NSLayoutConstraint(item: toolbar, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let toolbarRightConstraint = NSLayoutConstraint(item: toolbar, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let toolbarLeftConstraint = NSLayoutConstraint(item: toolbar, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            containerView.addConstraints([toolbarTopConstraint, toolbarRightConstraint, toolbarLeftConstraint])
            configurationHandler?(toolbar)
            self.bar = toolbar
        }
        // Adds UINavigationbar
        public func addNavigationbar(configurationHandler configurationHandler: ((UINavigationBar) -> Void)? = nil) {
            guard !hasBar else { fatalError("UIToolbar or UINavigationBar can only have one") }
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
            configurationHandler?(navigationBar)
            self.bar = navigationBar
        }
        // Adds ContentsView
        public func addContentsView(contentView: UIView) {
            guard !hasView else { fatalError("ContainerView can only have one") }
            containerView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            let mainViewTopConstraint = NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: containerView, attribute: .Right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: containerView, attribute: .Left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            self.contentView = contentView
        }
        // Adds UIScrollView
        public func addScrollView(configurationHandler configurationHandler: ((UIScrollView) -> Void)) {
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
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
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
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
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
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
            automaticallyAdjustsScrollViewInsets = false
            overlayView.backgroundColor = overlayBackgroundColor
            containerView.backgroundColor = containerViewBackgroundColor
            state = .Hide
        }
        public override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            adjustLayout()
        }
        public func present(sender: AnyObject? = nil) {
            state = .ShowAll
        }
        public func dismiss(sender: AnyObject? = nil) {
            state = .Hide
            dismissViewControllerAnimated(true, completion: nil)
        }
        dynamic func handleTap(gestureRecognizer: UITapGestureRecognizer) {
            dismiss()
        }
        dynamic func handleGestureDragging(gestureRecognizer: UIPanGestureRecognizer) {
            let gestureView = gestureRecognizer.view
            let point = gestureRecognizer.translationInView(gestureView)
            let originY = maxHeight - initializeHeight
            switch state {
            case .Show:
                switch gestureRecognizer.state {
                case .Began:
                    break
                case .Changed:
                    containerView.frame.origin.y += point.y
                    containerViewHeightConstraint?.constant = max(initializeHeight, maxHeight - containerView.frame.origin.y)
                    gestureRecognizer.setTranslation(CGPointZero, inView: gestureRecognizer.view)
                case .Ended, .Cancelled:
                    if containerView.frame.origin.y - originY > moveRange.down {
                        dismiss()
                    } else if (containerViewHeightConstraint?.constant ?? 0) - initializeHeight > moveRange.up {
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
            case .ShowAll:
                switch gestureRecognizer.state {
                case .Began:
                    scrollView?.scrollEnabled = false
                case .Changed:
                    let currentTransformY = containerView.transform.ty
                    containerView.transform = CGAffineTransformMakeTranslation(0, currentTransformY + point.y)
                    gestureRecognizer.setTranslation(CGPointZero, inView: gestureView)
                case .Ended, .Cancelled:
                    scrollView?.scrollEnabled = true
                    if containerView.transform.ty > moveRange.down {
                        dismiss()
                    } else {
                        let animations = {
                            self.containerView.transform = CGAffineTransformIdentity
                        }
                        UIView.performSystemAnimation(.Delete, onViews: [], options: [], animations: animations, completion: nil)
                    }
                default:
                    break
                }
            default:
                break
            }
        }
    }
}

// MARK: - private
private extension Bottomsheet.Controller {
    func configure() {
        modalPresentationStyle = .OverCurrentContext
        transitioningDelegate = self
        view.frame.size = UIScreen.mainScreen().bounds.size
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        overlayView.frame = UIScreen.mainScreen().bounds
        view.addSubview(overlayView)
        containerView.transform = CGAffineTransformMakeTranslation(0, initializeHeight)
        view.addSubview(containerView)
    }
    func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let containerViewHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: initializeHeight)
        let containerViewRightConstraint = NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0)
        let containerViewLeftConstraint = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0)
        let containerViewBottomLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraints([containerViewHeightConstraint, containerViewRightConstraint, containerViewLeftConstraint, containerViewBottomLayoutConstraint])
        self.containerViewHeightConstraint = containerViewHeightConstraint
    }
    func newState(state: State) {
        switch state {
        case .Hide:
            removeGesture(state)
            addGesture(state)
        case .Show:
            removeGesture(state)
            addGesture(state)
        case .ShowAll:
            removeGesture(state)
            addGesture(state)
        }
        transform(state)
    }
    func transform(state: State) {
        guard !isNeedLayout else { return }
        switch state {
        case .Hide:
            guard let containerViewHeightConstraint = containerViewHeightConstraint else { return }
            UIView.animateWithDuration(duration.hide) {
                self.containerView.transform = CGAffineTransformMakeTranslation(0, containerViewHeightConstraint.constant)
            }
        case .Show:
            UIView.animateWithDuration(duration.show) {
                self.containerView.transform = CGAffineTransformIdentity
            }
        case .ShowAll:
            containerViewHeightConstraint?.constant = maxHeight
            UIView.animateWithDuration(duration.showAll) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func adjustLayout() {
        guard isNeedLayout else { return }
        isNeedLayout = false
        if let bar = bar {
            containerView.bringSubviewToFront(bar)
        }
        configureGesture()
        scrollView?.setContentOffset(CGPoint(x: 0, y: -(scrollView?.scrollIndicatorInsets.top ?? 0)), animated: false)
        state = .Show
    }
    func configureGesture() {
        //
        overlayViewPanGestureRecognizer.addTarget(self, action: #selector(Bottomsheet.Controller.handleGestureDragging(_:)))
        overlayViewPanGestureRecognizer.delegate = self
        overlayViewTapGestureRecognizer.addTarget(self, action: #selector(Bottomsheet.Controller.handleTap(_:)))
        //
        panGestureRecognizer.addTarget(self, action: #selector(Bottomsheet.Controller.handleGestureDragging(_:)))
        panGestureRecognizer.delegate = self
        //
        barGestureRecognizer.addTarget(self, action: #selector(Bottomsheet.Controller.handleGestureDragging(_:)))
        barGestureRecognizer.delegate = self
        barGestureRecognizer.requireGestureRecognizerToFail(panGestureRecognizer)
    }
    func removeGesture(state: State) {
        switch state {
        case .Hide:
            overlayView.removeGestureRecognizer(overlayViewPanGestureRecognizer)
            overlayView.removeGestureRecognizer(overlayViewTapGestureRecognizer)
            containerView.removeGestureRecognizer(panGestureRecognizer)
            bar?.removeGestureRecognizer(barGestureRecognizer)
        case .Show:
            bar?.removeGestureRecognizer(barGestureRecognizer)
            containerView.removeGestureRecognizer(panGestureRecognizer)
        case .ShowAll:
            overlayView.removeGestureRecognizer(overlayViewPanGestureRecognizer)
            overlayView.removeGestureRecognizer(overlayViewTapGestureRecognizer)
        }
    }
    func addGesture(state: State) {
        switch viewActionType {
        case .Swipe:
            overlayView.addGestureRecognizer(overlayViewPanGestureRecognizer)
        case .TappedDismiss:
            overlayView.addGestureRecognizer(overlayViewTapGestureRecognizer)
        }
        switch state {
        case .Hide:
            break
        case .Show:
            bar?.addGestureRecognizer(barGestureRecognizer)
        case .ShowAll:
            bar?.addGestureRecognizer(barGestureRecognizer)
            containerView.addGestureRecognizer(panGestureRecognizer)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension Bottomsheet.Controller: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = scrollView, gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer where state == .ShowAll {
            let gestureView = gestureRecognizer.view
            let point = gestureRecognizer.translationInView(gestureView)
            let contentOffset = scrollView.contentOffset.y + scrollView.contentInset.top
            return contentOffset == 0 && point.y > 0
        }
        return true
    }
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        private typealias Animator = Bottomsheet.TransitionAnimator
        private static let presentAnimationDuration: NSTimeInterval = 0.3
        private static let dismissAnimationDuration: NSTimeInterval = 0.3
        private var presentDuration: NSTimeInterval?
        private var dismissDuration: NSTimeInterval?
        private var present: Bool?
        init(present: Bool, presentDuration: NSTimeInterval? = nil, dismissDuration: NSTimeInterval? = nil) {
            super.init()
            self.present = present
            self.presentDuration = presentDuration
            self.dismissDuration = dismissDuration
        }
        public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            if present == true {
                return presentDuration ?? Animator.presentAnimationDuration
            } else {
                return dismissDuration ?? Animator.dismissAnimationDuration
            }
        }
        public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            if present == true {
                presentAnimation(transitionContext)
            } else {
                dismissAnimation(transitionContext)
            }
        }
        // private
        private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
            if let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? Bottomsheet.Controller,
                containerView = transitionContext.containerView() {
                containerView.backgroundColor = UIColor.clearColor()
                containerView.addSubview(toVC.view)
                toVC.overlayView.alpha = 0
                let animations = {
                    toVC.overlayView.alpha = 1
                }
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: animations) { finished in
                    if finished {
                        let cancelled = transitionContext.transitionWasCancelled()
                        if cancelled {
                            toVC.view.removeFromSuperview()
                        }
                        transitionContext.completeTransition(!cancelled)
                    }
                }
            } else {
                transitionContext.completeTransition(false)
            }
        }
        private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
            if let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? Bottomsheet.Controller {
                let animations = {
                    fromVC.overlayView.alpha = 0
                }
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: animations) { finished in
                    if finished {
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    }
                }
            } else {
                transitionContext.completeTransition(false)
            }
        }
    }
}
