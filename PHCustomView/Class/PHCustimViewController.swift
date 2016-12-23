//
//  PHCustimViewController.swift
//  PHCustomView
//
//  Created by Mac on 16/12/22.
//  Copyright © 2016年 Lph. All rights reserved.
//

import UIKit

class PHCustimViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.yellow
      
        let dismissBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        dismissBtn.setTitle("关闭", for: .normal)
        dismissBtn.setTitleColor(UIColor.red, for: .normal)
        dismissBtn.addTarget(self, action: #selector(PHCustimViewController.dismissVc), for: .touchUpInside)
        
        self.view.addSubview(dismissBtn)
    }
    func dismissVc() {
        
        self.dismiss(animated: true, completion: nil)
        
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
