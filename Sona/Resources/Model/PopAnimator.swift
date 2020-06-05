//
//  PopAnimator.swift
//  Sona
//
//  Created by Tyler Cheek on 6/3/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class PopAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.5
    var presenting = true
    var originFrame = CGRect.init(origin: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY), size: CGSize(width: 0, height: 0))
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let homeScreenView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : homeScreenView.frame
        let finalFrame = presenting ? homeScreenView.frame : originFrame

        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width

        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
            homeScreenView.transform = scaleTransform
            homeScreenView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            homeScreenView.clipsToBounds = true
        }

        homeScreenView.layer.cornerRadius = presenting ? 20.0 : 0.0
        homeScreenView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(homeScreenView)

        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            animations: {
                homeScreenView.transform = self.presenting ? .identity : scaleTransform
                homeScreenView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                homeScreenView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
    
}
