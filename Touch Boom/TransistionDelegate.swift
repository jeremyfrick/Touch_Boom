//
//  TransistioningDelegate.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/18/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }
    
}
