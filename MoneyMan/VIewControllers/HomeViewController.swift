//
//  MainViewController.swift
//  MoneyMan
//
//  Created by Chandra on 19/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

   
    @IBOutlet weak var txtBalance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveBalanceFromFirestore()
        
        // Do any additional setup after loading the view.
        
        //GET TRANSACTIONS DATA
//        Firestore.firestore().collection("transaction").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid).getDocuments { (snapshot, error) in
//            if error != nil && snapshot != nil {
//                for document in snapshot!.documents {
//                    let documentData = document.data()
//
//                }
//
//            }
//        }
    }
    
    func retrieveBalanceFromFirestore() {
        let uid = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("balanceAndDebt").document(uid).getDocument { (document, error) in
            if error == nil{
                if document != nil && document!.exists{
                    if let data = document!.data() {
                        self.txtBalance.text = "IDR \(data["balance"] as! Int)"
                    }
                }
            }
        }
    }
}
