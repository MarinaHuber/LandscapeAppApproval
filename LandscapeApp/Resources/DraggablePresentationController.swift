//
//  DraggablePresentationController.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import UIKit

enum DragDirection {
//    case up
//    case down
    case left
    case right
}

enum DraggablePosition {
    case collapsed
    case open
//    case middle
    
    var widthMultiplier: CGFloat {
        switch self {
        case .collapsed:
            return 0.05
//        case .middle:
//            return 0.48
        case .open:
            return 0.48
        }
    }
    
    var rightBoundary: CGFloat {
        switch self {
        case .collapsed: return 0.0
//        case .middle: return 0.35
        case .open: return 0.35
        }
    }
    
    var leftBoundary: CGFloat {
        switch self {
        case .collapsed: return 0.0
//        case .middle: return 0.27
        case .open: return 0.27
        }
    }
    
    var dimAlpha: CGFloat {
        switch self {
        case .collapsed: return 0.0
        case .open: return 0.0
        }
    }
    
    func xOrigin(for maxWidth: CGFloat) -> CGFloat {
        return maxWidth - (maxWidth*widthMultiplier)
    }
    
    func nextPostion(for dragDirection: DragDirection) -> DraggablePosition {
        switch (self, dragDirection) {
        case (.collapsed, .left): return .open
        case (.collapsed, .right): return .collapsed
//        case (.middle, .left): return .open
//        case (.middle, .right): return .collapsed
        case (.open, .left): return .open
        case (.open, .right): return .collapsed
        }
    }
}

class DraggablePresentationController: UIPresentationController {
    
    
    private lazy var touchForwardingView: TouchForwardingView? = {
        guard let containerView = containerView else { return nil }
        return TouchForwardingView(frame: containerView.bounds)
    }()
    
    private var dimmingView = UIView()
    
    private var position: DraggablePosition = .open
    private var dragDirection: DragDirection = .left
    private var maxFrame = CGRect(x: UIScreen.main.bounds.width-514, y: 0, width: 514, height: UIScreen.main.bounds.height-75)
    
    private var animator: UIViewPropertyAnimator?
    private let springTiming = UISpringTimingParameters(dampingRatio: 0.9, initialVelocity: CGVector(dx: 10, dy: 0))
    private var panGesture = UIGestureRecognizer()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let origin = CGPoint(x: UIScreen.main.bounds.width-514, y: 75)
        let size = CGSize(width: maxFrame.width, height: maxFrame.height)
        let frame = CGRect(origin: origin, size: size)
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        //insert dimming view
        guard let containerView = containerView else { return }
        
        touchForwardingView!.passthroughViews = [presentingViewController.view]
        containerView.insertSubview(touchForwardingView!, at: 0)
        
        containerView.insertSubview(dimmingView, at: 1)
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .black
        dimmingView.frame = containerView.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        //set up touch gestures
        animator = UIViewPropertyAnimator(duration: 0.6, timingParameters: springTiming)
        animator?.isInterruptible = false
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(panRecognizer:)))
        presentedView?.addGestureRecognizer(panGesture)
        
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc private func userDidPan(panRecognizer: UIPanGestureRecognizer) {
        let translationPoint = panRecognizer.translation(in: presentedView)
        let velocity = panRecognizer.velocity(in: presentedView)
//        let currentOriginY = position.yOrigin(for: maxFrame.height)
        let currentOriginX = position.xOrigin(for: maxFrame.width)
        let newOffset = currentOriginX + translationPoint.x
        
        dragDirection = newOffset > currentOriginX ? .right : .left
        
        let canDragInProposedDirection = dragDirection == .left && position == .open ? false : true
        
        if canDragInProposedDirection {
            presentedView?.frame.origin.x = newOffset
//            let nextOriginY = position.nextPostion(for: dragDirection).yOrigin(for: maxFrame.height)
            let nextOriginX = position.nextPostion(for: dragDirection).xOrigin(for: maxFrame.width)
            let area = dragDirection == .left ? frameOfPresentedViewInContainerView.origin.x - maxFrame.origin.x : -(frameOfPresentedViewInContainerView.origin.x - nextOriginX)
            if newOffset != area && position == .open || position.nextPostion(for: dragDirection) == .open {
                let onePercent = area / 100
                let percentage = (area-newOffset) / onePercent / 100
                dimmingView.alpha = percentage * DraggablePosition.open.dimAlpha
            }
        }
        
        if panRecognizer.state == .ended {
            if velocity.x < -1000 {
                animate(to: position.nextPostion(for: .left))
            } else if velocity.x > 1000 {
                animate(to: position.nextPostion(for: .right))
            } else {
                animate(newOffset)
            }
        }
    }

    private func animate(_ dragOffset: CGFloat) {
        
        let distanceFromBottom = maxFrame.width - dragOffset
        
        switch dragDirection {
        case .left:
            if (distanceFromBottom > maxFrame.width * DraggablePosition.open.leftBoundary) {
                animate(to: .open)
                position = .open
//            } else if (distanceFromBottom > maxFrame.width * DraggablePosition.middle.leftBoundary ) {
//                animate(to: .middle)
//                position = .middle
            } else {
                animate(to: .collapsed)
                position = .collapsed
            }
            
        case .right:
            if (distanceFromBottom > maxFrame.width * DraggablePosition.open.rightBoundary) {
                animate(to: .open)
                position = .open
//            } else if (distanceFromBottom > maxFrame.width * DraggablePosition.middle.rightBoundary ) {
//                animate(to: .middle)
//                position = .middle
            } else {
                animate(to: .collapsed)
                position = .collapsed
            }
        }
    }
    
    private func animate(to position: DraggablePosition) {
        
        guard let animator = animator else { return }
        
        animator.addAnimations {
            self.presentedView?.frame.origin.x = position.xOrigin(for: self.maxFrame.width)
            self.dimmingView.alpha = position.dimAlpha
        }
        self.position = position
        animator.startAnimation()
    }
}
