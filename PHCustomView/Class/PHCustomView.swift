//
//  PHCustomView.swift
//  PHCustomView
//
//  Created by Mac on 16/12/20.
//  Copyright © 2016年 Lph. All rights reserved.
//

import UIKit

class PHCustomView: UIView {
    
    let parentView = UIView()
    var bomBoxView = UIView()
    var customContainerView = UIView()
    
    public var btnTitlesArr = NSArray()
    var btnHeight = 0
    var btnSpacerHeight = 0
    //Set to true support fullscreen click Delete mask & default false
    var isRemoveMask = Bool()
    // default true
    var isClickBtnSignOut = Bool()
    var customFrame = CGRect()
    var isCustomFrame = Bool()

    typealias onButtonTouchBlock = (_ alertView: PHCustomView, _ buttonIndex: NSInteger)->()
    
    var onButtonClickWithTagBlock: onButtonTouchBlock?
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        isClickBtnSignOut = true
    }
    
    func removeMaskView() {
        
        closeView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMpMoviePlayer"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func customBomBoxViewButtonTouchUp(inside alertView: Any, clickedButtonAt buttonIndex: Int){
        
        onButtonClickWithTagBlock!(self, (alertView as AnyObject).tag)
        
        if isClickBtnSignOut {
            self.closeView()
        }
    }
    
    
    func closeView() {
        
        let currentTransForm: CATransform3D = bomBoxView.layer.transform
        let startRotation = bomBoxView.value(forKeyPath: "layer.transform.rotation.z") as! CGFloat
        let rotation: CATransform3D = CATransform3DMakeRotation(-startRotation + CGFloat(M_PI) * 270.0, 0, 0, 0)
        bomBoxView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        bomBoxView.layer.opacity = 1.0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            self.bomBoxView.layer.transform = CATransform3DConcat(currentTransForm, CATransform3DMakeScale(0.6, 0.6, 1.0))
            self.bomBoxView.layer.opacity = 0
        }) { (_) in
            
            for v in self.subviews {
                v.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
    }
    
}


extension PHCustomView {
    
    public func show() {
        
        if isRemoveMask {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PHCustomView.removeMaskView)))
        }
        
        bomBoxView = self.createcustomContainerView()
        bomBoxView.layer.shouldRasterize = true
        bomBoxView.layer.rasterizationScale = UIScreen.main.scale
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        bomBoxView.layer.opacity = 0.5
        bomBoxView.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.0)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.addSubview(bomBoxView)
        
        let interOrientation = UIApplication.shared.statusBarOrientation
        
        switch interOrientation {
        case .landscapeLeft:
            self.transform = CGAffineTransform(rotationAngle: .pi * 270.0 / 180.0)
            break
        case .landscapeRight:
            self.transform = CGAffineTransform(rotationAngle: .pi * 90 / 180)
            break
        case .portraitUpsideDown:
            self.transform = CGAffineTransform(rotationAngle: .pi * 180 / 180)
            break
        default:
            break
        }
        
        self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIApplication.shared.windows.first?.addSubview(self)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.bomBoxView.layer.opacity = 1.0
            self.bomBoxView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { (_) in
        }
        
    }
    
    func customFrameWithcustomView(Rect: CGRect) {
    
        isCustomFrame = true
        customFrame = Rect
    }
    //MARK:设置自定义View的位置
    func createcustomContainerView() -> UIView {
        
        let screenSize = self.ph_countScreenSize()
        let bomBoxSize = self.ph_countbomBoxSize()
        
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        let bomBoxContainer = UIView()
        if isCustomFrame {
            
            bomBoxContainer.frame = customFrame
        } else {
            
            bomBoxContainer.frame = CGRect(x: (screenSize.width - bomBoxSize.width) / 2, y: (screenSize.height - bomBoxSize.height) / 2, width: bomBoxSize.width, height: bomBoxSize.height)
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = bomBoxContainer.bounds
        gradient.colors = NSArray(objects: UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor, UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor, UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor) as? [Any]
        
        let cornerRadius:CGFloat = 7.0
        
        gradient.cornerRadius = cornerRadius
        bomBoxContainer.layer.insertSublayer(gradient, at: 0)
        
        bomBoxContainer.layer.cornerRadius = cornerRadius
        bomBoxContainer.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        bomBoxContainer.layer.borderWidth = 1
        bomBoxContainer.layer.shadowRadius = cornerRadius + 5.0
        bomBoxContainer.layer.shadowOpacity = 0.1
        bomBoxContainer.layer.shadowOffset = CGSize(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5)/2)
        bomBoxContainer.layer.shadowColor = UIColor.black.cgColor
        bomBoxContainer.layer.shadowPath = UIBezierPath(roundedRect: bomBoxContainer.bounds, cornerRadius: bomBoxContainer.layer.cornerRadius).cgPath
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: bomBoxContainer.bounds.size.height - CGFloat(btnHeight), width: bomBoxContainer.bounds.size.width, height: CGFloat(btnSpacerHeight))
    
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        bomBoxContainer.addSubview(lineView)
        bomBoxContainer.addSubview(customContainerView)
        
        self.addButtonsToView(container: bomBoxContainer)
        
        return bomBoxContainer
    }
    // TODO: 添加按钮
    func addButtonsToView(container: UIView) {
        
        if btnTitlesArr.count <= 0 {
            return
        }
        
        let buttonWidth = container.bounds.size.width / CGFloat(btnTitlesArr.count)
        for i in 0..<btnTitlesArr.count {
            
            let closeButton = UIButton(type: .custom)
            closeButton.frame = CGRect(x: CGFloat(i) * buttonWidth, y: container.bounds.size.height - CGFloat(btnHeight), width: buttonWidth, height: CGFloat(btnHeight))
            closeButton.addTarget(self, action: #selector(customBomBoxViewButtonTouchUp(inside:clickedButtonAt:)), for: .touchUpInside)
            closeButton.tag = i
            let buttonTitle = btnTitlesArr.object(at: i) as? String
            closeButton.setTitle(buttonTitle, for: .normal)
            closeButton.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), for: .normal)
            closeButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0), for: .highlighted)
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            closeButton.layer.cornerRadius = 7
            
            container.addSubview(closeButton)
        }
        
    }
    
    
    public func custonmDeviceOrientationDidChange(notification: Notification) {
        
        let interOrientation = UIApplication.shared.statusBarOrientation
        let startRotation = self.value(forKeyPath: "layer.transform.rotation.z") as! Double
        var rotation = CGAffineTransform()
        let floatValue1 = -startRotation + M_PI * 270 / 180
        let floatValue2 = -startRotation + M_PI * 90 / 180
        let floatValue3 = -startRotation + M_PI * 180 / 180
        switch interOrientation {
        case .landscapeLeft:
            rotation = CGAffineTransform(rotationAngle: CGFloat(floatValue1))
            break
            
        case .landscapeRight:
            rotation = CGAffineTransform(rotationAngle: CGFloat(floatValue2))
            break
            
        case .portraitUpsideDown:
            rotation = CGAffineTransform(rotationAngle: CGFloat(floatValue3))
            break
            
        default:
            rotation = CGAffineTransform(rotationAngle: CGFloat(-startRotation + 0.0))
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bomBoxView.transform = rotation
        }) { (_) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
            })
            
        }
        
    }

    func keyboardWillShow(notification: NSNotification) {
        
        
        let screenSize = self.ph_countScreenSize()
        let bomBoxSize = self.ph_countbomBoxSize()
        
        let tmpObj: [NSObject: AnyObject] = notification.userInfo! as [NSObject : AnyObject]
        let userInfoDic: NSDictionary = tmpObj as NSDictionary
        let dicValue = userInfoDic[UIKeyboardFrameBeginUserInfoKey].debugDescription
        var keyboardSize: CGSize = CGRectFromString(dicValue).size
        
        let interOrientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsLandscape(interOrientation) {
            let tmp = keyboardSize.height
            keyboardSize.height = keyboardSize.width
            keyboardSize.width = tmp
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bomBoxView.frame = CGRect(x: (screenSize.width - bomBoxSize.width) / 2, y: (screenSize.height - bomBoxSize.height - keyboardSize.height) / 2, width: bomBoxSize.width, height: bomBoxSize.height)
        }) { (_) in
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let screenSize = self.ph_countScreenSize()
        let bomBoxSize = self.ph_countbomBoxSize()
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(0)), animations: {
            
            self.bomBoxView.frame = CGRect(x: (screenSize.width - bomBoxSize.width) / 2, y: (screenSize.height - bomBoxSize.height) / 2, width: bomBoxSize.width, height: bomBoxSize.height)
            
        }) { (_) in
            
        }
    }
    
    func ph_countScreenSize() -> CGSize {
        
        if btnTitlesArr.count > 0{
            
            btnHeight = 40
            btnSpacerHeight = 1
        } else {
            
            btnHeight = 0
            btnSpacerHeight = 0
        }
        
        var screenWidth = UIScreen.main.bounds.size.width
        var screenHeight = UIScreen.main.bounds.size.height
        let interOrientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsLandscape(interOrientation) {
            
            let tmp = screenWidth
            screenWidth = screenHeight
            screenHeight = tmp
        }
        
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    func ph_countbomBoxSize() -> CGSize {
        
        let dialogWidth = customContainerView.frame.size.width
        let dialogHeight = customContainerView.frame.size.height + (CGFloat(btnHeight)) + (CGFloat(btnSpacerHeight))
        
        return CGSize(width: dialogWidth, height: dialogHeight)
        
    }
    
}
