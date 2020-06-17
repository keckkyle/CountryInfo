//
//  SlideOver.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/14/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import UIKit

//class to control animations in navigation
class SlideOver: NSObject, UIViewControllerAnimatedTransitioning {
    
    //hold boolean values for pop and directiong
    var pop: Bool = false
    var slideRight: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //if the animation is a pop animation call pop function
        if pop {
            animatePop(using: transitionContext)
            return
        }
        
        //set the to and from controllers
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let f = transitionContext.finalFrame(for: tz)

        var fOff = f.offsetBy(dx: f.width, dy: 0)
        //check if view should move right and reset if so
        if slideRight {
            fOff = f.offsetBy(dx: -f.width, dy: 0)
        }
        
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })

    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning){
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 0)

        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
    
}
