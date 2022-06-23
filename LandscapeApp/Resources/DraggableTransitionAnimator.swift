//
//  DraggableTransitionAnimator.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import Foundation
import UIKit

open class DraggableTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let vcToPresent: UIViewController
    private weak var presentingVC: UIViewController?
    
    public init(viewControllerToPresent: UIViewController, presentingViewController: UIViewController) {
        vcToPresent = viewControllerToPresent
        presentingVC = presentingViewController
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // initialize presentation controller here
        return DraggablePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
