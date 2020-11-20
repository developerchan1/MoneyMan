//
//  AddTransactionViewController.swift
//  MoneyMan
//
//  Created by Chandra on 20/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //ADD TRANSACTION
        //Firestore.firestore().collection("transaction").addDocument(data: ["name" : "Makan ayam", "category" : "Expense", "method" : "Cash", "price" : 10000, "description" : "makanan enak dan murah", "uid" : Auth.auth().currentUser?.uid ?? ""])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
