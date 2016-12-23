//
//  PHPresentingAnimator.swift
//  PHCustomView
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Lph. All rights reserved.
//

import UIKit
import pop

class PHPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewController(forKey: .from)!.view
        fromView?.tintAdjustmentMode = .dimmed
        let dimmingView = UIView(frame: (fromView?.bounds)!)
        dimmingView.backgroundColor = UIColor.black
        dimmingView.layer.opacity = 0.0
        let toView = transitionContext.viewController(forKey: .to)!.view
        toView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(transitionContext.containerView.bounds.width - 60), height: CGFloat(transitionContext.containerView.bounds.height - 200))
        toView?.center = CGPoint(x: CGFloat(transitionContext.containerView.center.x), y: CGFloat(-transitionContext.containerView.center.y))
        transitionContext.containerView.addSubview(dimmingView)
        transitionContext.containerView.addSubview(toView!)
       
        
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        positionAnimation?.toValue = (transitionContext.containerView.center.y)
        positionAnimation?.springBounciness = 10

        transitionContext.completeTransition(true)
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.springBounciness = 20
        scaleAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(1.2), y: CGFloat(1.4)))
        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        opacityAnimation?.toValue = (0.2)
        toView?.layer.pop_add(positionAnimation, forKey: "positionAnimation")
        toView?.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
        dimmingView.layer.pop_add(opacityAnimation, forKey: "opacityAnimation")

    }

}
