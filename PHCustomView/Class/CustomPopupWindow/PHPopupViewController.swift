//
//  PHPopupViewController.swift
//  PHCustomView
//
//  Created by Mac on 17/1/11.
//  Copyright © 2017年 Lph. All rights reserved.
//

import UIKit

class PHPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // 这里自定义弹出View的尺寸
        self.view.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let closeBtn = UIButton(type: .custom)
    
        closeBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        closeBtn.setTitle("closeView", for: .normal)
        closeBtn.setTitleColor(.blue, for: .normal)
        closeBtn.addTarget(PHPopupWindowView(), action: #selector(closeBtnClick), for: .touchUpInside)
        
        self.view.addSubview(closeBtn)
    }
    
    func closeBtnClick() {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
