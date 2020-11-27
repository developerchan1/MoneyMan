//
//  CustomTabViewController.swift
//  MoneyMan
//
//  Created by Chandra on 24/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import STTabbar

class CustomTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.centerButtonActionHandler = {
                //show add transaction page
                self.performSegue(withIdentifier: "addTransactionSegue", sender: self)
            }
        }
    }
    
    @IBAction func unwindToTabViewController(_ unwindSegue: UIStoryboardSegue) {
        //do nothing
    }
}
