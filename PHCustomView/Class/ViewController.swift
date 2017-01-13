//
//  ViewController.swift
//  PHCustomView
//
//  Created by Mac on 16/12/20.
//  Copyright © 2016年 Lph. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    
    let mvPlayer = MPMoviePlayerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
  
    @IBAction func showCustomViewClick(_ sender: AnyObject) {
        
        let alertView = PHCustomView()
        alertView.btnTitlesArr = NSArray(objects: "保存", "取消", "重置")
        // 默认不支持全屏remove Mask
//        alertView.isRemoveMask = true
        let demoView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        let title = UILabel(frame: CGRect(x: 120, y: 10, width: 180, height: 20))
        title.text = "设置"
        demoView.addSubview(title)
        
        let textField = UITextField(frame: CGRect(x: 10, y: 50, width: 270, height: 30))
        textField.placeholder = "请输入要修改的密码"
        textField.backgroundColor = UIColor.white
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        let textField1 = UITextField(frame: CGRect(x: 10, y: 95, width: 270, height: 30))
        textField1.placeholder = "请再次确认修改的密码"
        textField1.backgroundColor = UIColor.white
        textField1.isSecureTextEntry = true
        textField1.font = UIFont.systemFont(ofSize: 14)
        
        demoView.addSubview(textField)
        demoView.addSubview(textField1)
        alertView.customContainerView = demoView
        alertView.show()
        
        alertView.onButtonClickWithTagBlock = {(_ alertView: PHCustomView, _ buttonIndex: Int) -> Void in
            
            //这里判断按钮索引来做相应的操作
            if buttonIndex == 0 {
                
                alertView.isClickBtnSignOut = true
                print("Did Preservation Btn")
            }
            
            if buttonIndex == 1 {
                
                alertView.isClickBtnSignOut = true
                print("Did Cancel Btn")
            }
            
            if buttonIndex == 2 {
                
                textField.text = ""
                textField1.text = ""
                textField.becomeFirstResponder()
                
                //设置为NO就不从屏幕移除
                alertView.isClickBtnSignOut = false
            }
        }
    }
    

    @IBAction func showAnimatorController(_ sender: AnyObject) {

        let viewVc = PHCustimViewController()
        viewVc.transitioningDelegate = self
        viewVc.modalPresentationStyle = .custom
        
        self.present(viewVc, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PHPresentingAnimator()
    }
    
    
    @IBAction func showMoviePlayerView(_ sender: AnyObject) {
        
        let alertView = PHCustomView()
        // 自定义customView的Frame
        alertView.customFrameWithcustomView(Rect: CGRect(x: self.view.frame.size.width / 2 - 150, y: 400, width: 300, height: 200))
        alertView.isRemoveMask = true
        mvPlayer.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        mvPlayer.controlStyle = .default
        mvPlayer.repeatMode = .one
        alertView.customContainerView = mvPlayer.view

        mvPlayer.contentURL = URL(string: "http://pl.youku.com/playlist/m3u8?vid=370551814&type=mp4&ts=1456536121&keyframe=0&ep=dCaRHEyOUM8C5CfYjD8bZH23ciNcXP0N9hqAgNpjBNQmQeq7&sid=6456536121474123ae6dc&token=2924&ctype=12&ev=1&oip=465375064")
        mvPlayer.prepareToPlay()
        mvPlayer.play()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didStopMpMoviePlayer), name: NSNotification.Name(rawValue: "stopMpMoviePlayer"), object: nil)
        
        alertView.show()
    }

    func didStopMpMoviePlayer() {
    
        mvPlayer.stop()
        mvPlayer.view.removeFromSuperview()
    }

    @IBAction func showPopupWindowView(_ sender: AnyObject) {
        
        let vc = PHPopupViewController()
        
        let pop = PHPopupWindowView.popupWindowWithView(popupView: vc.view)
        pop.scaleNum = 0.7  //自定义缩小比例 & 默认0.5
        pop.showPopupView() //show出modalView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {

    
}

