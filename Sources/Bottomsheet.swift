//
//  Bottomsheet.swift
//  Pods
//
//  Created by hiroyuki yoshida on 2015/10/17.
//
//

import UIKit

open class Bottomsheet {
    open class Controller: UIViewController {
        public enum OverlayViewActionType {
            case swipe, tappedDismiss
        }
        // public
        open var initializeHeight: CGFloat = 300 {
            didSet {
                containerViewHeightConstraint?.constant = initializeHeight
            }
        }
        open var maxHeight: CGFloat = UIScreen.main.bounds.height
        open var viewActionType: Bottomsheet.Controller.OverlayViewActionType = .tappedDismiss
        open var moveRange: (down: CGFloat, up: CGFloat) = (150, 100)
        open var duration: (hide: TimeInterval, show: TimeInterval, showAll: TimeInterval) = (0.3, 0.3, 0.3)
        // OverlayView
        open let overlayView = UIView()
        open var overlayBackgroundColor: UIColor? {
            set { overlayView.backgroundColor = newValue }
            get { return overlayView.backgroundColor }
        }
        // ContainerView
        open let containerView = UIView()
        open var containerViewBackgroundColor = UIColor(white: 1, alpha: 1)
        // private
        fileprivate var containerViewHeightConstraint: NSLayoutConstraint?
        fileprivate enum State {
            case hide
            case show
            case showAll
        }
        fileprivate var state: State = .hide {
            didSet {
                newState(state)
            }
        }
        fileprivate var isNeedLayout = true
        fileprivate var bar: UIView?
        // gesture
        fileprivate var overlayViewPanGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate var overlayViewTapGestureRecognizer: UITapGestureRecognizer = {
            let gestureRecognizer = UITapGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate var panGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        fileprivate var barGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            return gestureRecognizer
        }()
        //
        fileprivate var contentView: UIView?
        fileprivate var scrollView: UIScrollView?
        fileprivate var hasBar: Bool {
            if let _ = bar {
                return true
            }
            return false
        }
        fileprivate var hasView: Bool {
            if let _ = contentView {
                return true
            } else if let _ = scrollView {
                return true
            }
            return false
        }
        fileprivate var isDismissing = false
        public convenience init() {
            self.init(nibName: nil, bundle: nil)
            configure()
            configureConstraints()
        }
        // Adds UIToolbar
        open func addToolbar(_ configurationHandler: ((UIToolbar) -> Void)? = nil) {
            guard !hasBar else { fatalError("UIToolbar or UINavigationBar can only have one") }
            let toolbar = UIToolbar()
            containerView.addSubview(toolbar)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            let toolbarTopConstraint = NSLayoutConstraint(item: toolbar, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let toolbarRightConstraint = NSLayoutConstraint(item: toolbar, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            let toolbarLeftConstraint = NSLayoutConstraint(item: toolbar, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            containerView.addConstraints([toolbarTopConstraint, toolbarRightConstraint, toolbarLeftConstraint])
            configurationHandler?(toolbar)
            self.bar = toolbar
        }
        // Adds UINavigationbar
        open func addNavigationbar(configurationHandler: ((UINavigationBar) -> Void)? = nil) {
            guard !hasBar else { fatalError("UIToolbar or UINavigationBar can only have one") }
            let naviBar = UINavigationBar()
            naviBar.sizeToFit()
            let navigationBar = NavigationBar()
            navigationBar.height = naviBar.frame.height
            containerView.addSubview(navigationBar)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            let navigationbarTopConstraint = NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let navigationbarRightConstraint = NSLayoutConstraint(item: navigationBar, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            let navigationbarLeftConstraint = NSLayoutConstraint(item: navigationBar, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            containerView.addConstraints([navigationbarTopConstraint, navigationbarRightConstraint, navigationbarLeftConstraint])
            configurationHandler?(navigationBar)
            self.bar = navigationBar
        }
        // Adds ContentsView
        open func addContentsView(_ contentView: UIView) {
            guard !hasView else { fatalError("ContainerView can only have one") }
            containerView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            let mainViewTopConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            self.contentView = contentView
        }
        // Adds UIScrollView
        open func addScrollView(configurationHandler: ((UIScrollView) -> Void)) {
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
            let scrollView = UIScrollView()
            containerView.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            configurationHandler(scrollView)
            let mainViewTopConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            self.scrollView = scrollView
        }
        // Adds UICollectionView
        open func addCollectionView(_ flowLayout: UICollectionViewFlowLayout? = nil, configurationHandler: ((UICollectionView) -> Void)) {
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
            let mainViewTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            collectionView.reloadData()
            self.scrollView = collectionView
        }
        // Adds UITableView
        open func addTableView(configurationHandler: ((UITableView) -> Void)) {
            guard !hasView else { fatalError("ContainerView can only have one \(containerView.subviews)") }
            let tableView = UITableView(frame: CGRect.zero)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(tableView)
            configurationHandler(tableView)
            let mainViewTopConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
            let mainViewRightConstraint = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)
            let mainViewLeftConstraint = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
            let mainViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
            containerView.addConstraints([mainViewTopConstraint, mainViewLeftConstraint, mainViewRightConstraint, mainViewBottomConstraint])
            tableView.reloadData()
            self.scrollView = tableView
        }
        // Life cycle
        open override func viewDidLoad() {
            super.viewDidLoad()
            automaticallyAdjustsScrollViewInsets = false
            overlayView.backgroundColor = overlayBackgroundColor
            containerView.backgroundColor = containerViewBackgroundColor
            state = .hide
        }
        open override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            adjustLayout()
        }
        open func present(_ sender: AnyObject? = nil) {
            state = .showAll
        }
        open func dismiss(_ sender: AnyObject? = nil) {
            state = .hide
            dismiss(animated: true, completion: nil)
        }
        dynamic func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            dismiss()
        }
        dynamic func handleGestureDragging(_ gestureRecognizer: UIPanGestureRecognizer) {
            let gestureView = gestureRecognizer.view
            let point = gestureRecognizer.translation(in: gestureView)
            let originY = maxHeight - initializeHeight
            switch state {
            case .show:
                switch gestureRecognizer.state {
                case .began:
                    break
                case .changed:
                    containerView.frame.origin.y += point.y
                    containerViewHeightConstraint?.constant = max(initializeHeight, maxHeight - containerView.frame.origin.y)
                    gestureRecognizer.setTranslation(CGPoint.zero, in: gestureRecognizer.view)
                case .ended, .cancelled:
                    if containerView.frame.origin.y - originY > moveRange.down {
                        dismiss()
                    } else if (containerViewHeightConstraint?.constant ?? 0) - initializeHeight > moveRange.up {
                        present()
                    } else {
                        let animations = {
                            self.containerView.frame.origin.y = originY
                        }
                        UIView.perform(.delete, on: [], options: [], animations: animations, completion: nil)
                    }
                default:
                    break
                }
                let rate = (containerView.frame.origin.y - (originY))  / (containerView.frame.height)
                overlayView.alpha = max(0, min(1, (1 - rate)))
            case .showAll:
                switch gestureRecognizer.state {
                case .began:
                    scrollView?.isScrollEnabled = false
                case .changed:
                    let currentTransformY = containerView.transform.ty
                    containerView.transform = CGAffineTransform(translationX: 0, y: currentTransformY + point.y)
                    gestureRecognizer.setTranslation(CGPoint.zero, in: gestureView)
                case .ended, .cancelled:
                    scrollView?.isScrollEnabled = true
                    if containerView.transform.ty > moveRange.down {
                        dismiss()
                    } else {
                        let animations = {
                            self.containerView.transform = CGAffineTransform.identity
                        }
                        UIView.perform(.delete, on: [], options: [], animations: animations, completion: nil)
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
        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = self
        view.frame.size = UIScreen.main.bounds.size
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        overlayView.frame = UIScreen.main.bounds
        view.addSubview(overlayView)
        containerView.transform = CGAffineTransform(translationX: 0, y: initializeHeight)
        view.addSubview(containerView)
    }
    func configureConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let containerViewHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: initializeHeight)
        let containerViewRightConstraint = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let containerViewLeftConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let containerViewBottomLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([containerViewHeightConstraint, containerViewRightConstraint, containerViewLeftConstraint, containerViewBottomLayoutConstraint])
        self.containerViewHeightConstraint = containerViewHeightConstraint
    }
    func newState(_ state: State) {
        switch state {
        case .hide:
            removeGesture(state)
            addGesture(state)
        case .show:
            removeGesture(state)
            addGesture(state)
        case .showAll:
            removeGesture(state)
            addGesture(state)
        }
        transform(state)
    }
    func transform(_ state: State) {
        guard !isNeedLayout else { return }
        switch state {
        case .hide:
            guard let containerViewHeightConstraint = containerViewHeightConstraint else { return }
            UIView.animate(withDuration: duration.hide, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: containerViewHeightConstraint.constant)
            }) 
        case .show:
            UIView.animate(withDuration: duration.show, animations: {
                self.containerView.transform = CGAffineTransform.identity
            }) 
        case .showAll:
            containerViewHeightConstraint?.constant = maxHeight
            UIView.animate(withDuration: duration.showAll, animations: {
                self.view.layoutIfNeeded()
            }) 
        }
    }
    func adjustLayout() {
        guard isNeedLayout else { return }
        isNeedLayout = false
        if let bar = bar {
            containerView.bringSubview(toFront: bar)
        }
        configureGesture()
        scrollView?.setContentOffset(CGPoint(x: 0, y: -(scrollView?.scrollIndicatorInsets.top ?? 0)), animated: false)
        state = .show
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
        barGestureRecognizer.require(toFail: panGestureRecognizer)
    }
    func removeGesture(_ state: State) {
        switch state {
        case .hide:
            overlayView.removeGestureRecognizer(overlayViewPanGestureRecognizer)
            overlayView.removeGestureRecognizer(overlayViewTapGestureRecognizer)
            containerView.removeGestureRecognizer(panGestureRecognizer)
            bar?.removeGestureRecognizer(barGestureRecognizer)
        case .show:
            bar?.removeGestureRecognizer(barGestureRecognizer)
            containerView.removeGestureRecognizer(panGestureRecognizer)
        case .showAll:
            overlayView.removeGestureRecognizer(overlayViewPanGestureRecognizer)
            overlayView.removeGestureRecognizer(overlayViewTapGestureRecognizer)
        }
    }
    func addGesture(_ state: State) {
        switch viewActionType {
        case .swipe:
            overlayView.addGestureRecognizer(overlayViewPanGestureRecognizer)
        case .tappedDismiss:
            overlayView.addGestureRecognizer(overlayViewTapGestureRecognizer)
        }
        switch state {
        case .hide:
            break
        case .show:
            bar?.addGestureRecognizer(barGestureRecognizer)
            if scrollView == nil {
                containerView.addGestureRecognizer(panGestureRecognizer)
            }
        case .showAll:
            bar?.addGestureRecognizer(barGestureRecognizer)
            containerView.addGestureRecognizer(panGestureRecognizer)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension Bottomsheet.Controller: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = scrollView, let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer , state == .showAll {
            let gestureView = gestureRecognizer.view
            let point = gestureRecognizer.translation(in: gestureView)
            let contentOffset = scrollView.contentOffset.y + scrollView.contentInset.top
            return contentOffset == 0 && point.y > 0
        }
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension Bottomsheet.Controller: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Bottomsheet.TransitionAnimator(present: true)
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Bottomsheet.TransitionAnimator(present: false)
    }
}

// MARK: - NavigationBar
extension Bottomsheet {
    open class NavigationBar: UINavigationBar {
        var height: CGFloat = 44
        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            var barSize = super.sizeThatFits(size)
            barSize.height += UIApplication.shared.statusBarFrame.height
            return barSize
        }
        open override func layoutSubviews() {
            super.layoutSubviews()
            frame.size.height = height + UIApplication.shared.statusBarFrame.height
        }
    }
}

// MARK: - TransitionAnimator
extension Bottomsheet {
    open class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        fileprivate typealias Animator = Bottomsheet.TransitionAnimator
        fileprivate static let presentAnimationDuration: TimeInterval = 0.3
        fileprivate static let dismissAnimationDuration: TimeInterval = 0.3
        fileprivate var presentDuration: TimeInterval?
        fileprivate var dismissDuration: TimeInterval?
        fileprivate var present: Bool?
        init(present: Bool, presentDuration: TimeInterval? = nil, dismissDuration: TimeInterval? = nil) {
            super.init()
            self.present = present
            self.presentDuration = presentDuration
            self.dismissDuration = dismissDuration
        }
        open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            if present == true {
                return presentDuration ?? Animator.presentAnimationDuration
            } else {
                return dismissDuration ?? Animator.dismissAnimationDuration
            }
        }
        open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            if present == true {
                presentAnimation(transitionContext)
            } else {
                dismissAnimation(transitionContext)
            }
        }
        // private
        fileprivate func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
            guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? Bottomsheet.Controller else {
                transitionContext.completeTransition(false)
                return
            }
            let containerView = transitionContext.containerView
            containerView.backgroundColor = .clear
            containerView.addSubview(toVC.view)
            toVC.overlayView.alpha = 0
            let animations = {
                toVC.overlayView.alpha = 1
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: animations) { finished in
                if finished {
                    let cancelled = transitionContext.transitionWasCancelled
                    if cancelled {
                        toVC.view.removeFromSuperview()
                    }
                    transitionContext.completeTransition(!cancelled)
                }
            }
        }
        fileprivate func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
            guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? Bottomsheet.Controller else {
                transitionContext.completeTransition(false)
                return
            }
            let animations = {
                fromVC.overlayView.alpha = 0
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: animations) { finished in
                if finished {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
    }
}
