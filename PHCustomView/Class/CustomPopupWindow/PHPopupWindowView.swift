//
//  PHPopupWindowView.swift
//  PHCustomView
//
//  Created by Mac on 17/1/11.
//  Copyright © 2017年 Lph. All rights reserved.
//

import UIKit
import QuartzCore

let mainScreen = UIScreen.main.bounds.size
let windowRootView = UIApplication.shared.keyWindow?.rootViewController?.view

class PHPopupWindowView: UIView {
    
    var modalView = UIView()
    var blackView = UIView()
    var backGroundShadowView = UIView()
    var renderViewImage = UIImageView()
    var scaleNum:CGFloat = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func popupWindowWithView(popupView: UIView)->PHPopupWindowView {
        
        var viewRect = CGRect(x: 0, y: 0, width: (windowRootView?.frame.size.width)!, height: (windowRootView?.frame.size.height)!)
        
        if windowRootView?.transform.b != 0 && windowRootView?.transform.c != 0 {
            viewRect = CGRect(x: 0, y: 0, width: (windowRootView?.frame.size.height)!, height: (windowRootView?.frame.size.width)!)
        }
        
        let showView = PHPopupWindowView(frame: viewRect)
        showView.modalView = UIView(frame: CGRect(x: 0, y: 0, width: mainScreen.width, height: mainScreen.height))
        showView.modalView.backgroundColor = UIColor.clear
        showView.modalView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
        
        showView.blackView = UIView(frame: showView.frame)
        showView.blackView.backgroundColor = UIColor.black
        showView.blackView.autoresizingMask = showView.modalView.autoresizingMask
        
        showView.backGroundShadowView = UIView(frame: showView.frame)
        showView.backGroundShadowView.backgroundColor = UIColor.black
        showView.backGroundShadowView.alpha = 0
        showView.backGroundShadowView.autoresizingMask = showView.modalView.autoresizingMask
        
        showView.renderViewImage = UIImageView(frame: showView.frame)
        showView.renderViewImage.autoresizingMask = showView.modalView.autoresizingMask
        showView.renderViewImage.contentMode = .scaleToFill
        showView.renderViewImage.isUserInteractionEnabled = true
        
        showView.modalView.addSubview(popupView)
        showView.addSubview(showView.blackView)
        showView.addSubview(showView.renderViewImage)
        showView.addSubview(showView.backGroundShadowView)
        showView.addSubview(showView.modalView)
        
        return showView
    }
    
    public func showPopupView() {
        
        var viewRect = CGRect(x: 0, y: 0, width: (windowRootView?.frame.size.width)!, height: (windowRootView?.frame.size.height)!)
        if windowRootView?.transform.b != 0 && windowRootView?.transform.c != 0{
            viewRect = CGRect(x: 0, y: 0, width: (windowRootView?.frame.size.height)!, height: (windowRootView?.frame.size.width)!)
        }
        
        self.frame = viewRect
        
        UIGraphicsBeginImageContextWithOptions(renderViewImage.frame.size, (windowRootView?.isOpaque)!, UIScreen.main.scale)
        windowRootView?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let rootViewrenderViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        renderViewImage.image = rootViewrenderViewImage
        backGroundShadowView.alpha = 0
        windowRootView?.addSubview(self)
        modalView.center = CGPoint(x: self.frame.size.width / 2, y: modalView.frame.size.height * 1.5)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            
            self.backGroundShadowView.alpha = 0.5
            self.renderViewImage.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: -0.0007, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1))
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                let w = self.renderViewImage.frame.size.width * self.scaleNum
                let h = self.renderViewImage.frame.size.height * self.scaleNum
                self.renderViewImage.frame = CGRect(x: (mainScreen.width - w) / 2, y: 22, width: w, height: h)
                self.renderViewImage.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1))
                
                }, completion: { (_) in
                    
            })
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            
            self.modalView.center = self.center
            
        }) { (_) in
            
        }
    }
    
    func closeBtnClick() {
        
        hidePopupView()
    }
    
    func hidePopupView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.modalView.center = CGPoint(x: self.frame.size.width / 2, y: self.modalView.frame.size.height * 1.5)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.backGroundShadowView.alpha = 0
            self.renderViewImage.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: -0.0007, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1))
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                self.renderViewImage.frame = UIScreen.main.bounds
                self.renderViewImage.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3D(m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1))
                
                }, completion: { (_) in
                    
                    self .removeFromSuperview()
            })
        }
    }
    
}
