//
//  WalletViewController.swift
//  MoneyMan
//
//  Created by Chandra on 20/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class WalletViewController: UIViewController {

    @IBOutlet weak var txtBalance: UILabel!
    @IBOutlet weak var txtDebt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveBalanceAndDebtFromFirestore()
        // Do any additional setup after loading the view.
    }
    
    func retrieveBalanceAndDebtFromFirestore() {
         let uid = Auth.auth().currentUser!.uid
         Firestore.firestore().collection("balanceAndDebt").document(uid).getDocument { (document, error) in
             if error == nil{
                 if document != nil && document!.exists{
                     if let data = document!.data() {
                         self.txtBalance.text = "IDR \(data["balance"] as! Int)"
                         self.txtDebt.text = "IDR \(data["debt"] as! Int)"
                     }
                 }
             }
         }
     }
}
