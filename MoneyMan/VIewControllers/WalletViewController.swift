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
    @IBOutlet weak var balanceCard: UIView!
    @IBOutlet weak var debtCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //for balance card
        addGradientToView(forBalance: true)
        //for debt card
        addGradientToView(forBalance: false)
        
        retrieveBalanceAndDebtFromFirestore()
    }
    
    func retrieveBalanceAndDebtFromFirestore() {
        let uid = Auth.auth().currentUser!.uid

        //show loading alert while fetch data from firestore
        self.showLoadingAlert()

        Firestore.firestore().collection("balanceAndDebt").document(uid).getDocument { (document, error) in
            if error == nil{
                if document != nil && document!.exists{
                    if let data = document!.data() {
                        // print balance ke string
                        
                        self.txtBalance.text = Tools.printBalance(data["balance"] as! Int)
                        
                        self.txtDebt.text = Tools.printBalance(data["debt"] as! Int)
                    }
                }
            }
            //hide loading alert while data fetched from firestore
            self.dismissLoadingAlert()
        }
    }
    
    func addGradientToView(forBalance : Bool){
        //set card style
        if forBalance {
            //set corner radius and give shadow to the card
            UIUtil.roundedCornerCardStyle(balanceCard)
            balanceCard.layer.insertSublayer(gradientLayer(forBalance : true), at : 0)
        }
        else {
            //set corner radius and give shadow to the card
            UIUtil.roundedCornerCardStyle(debtCard)
            debtCard.layer.insertSublayer(gradientLayer(forBalance : false), at : 0)
        }
        
    }
    
    func gradientLayer (forBalance : Bool) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        
        if forBalance {
            gradientLayer.frame = balanceCard.bounds
            gradientLayer.colors = [UIColor.balanceGradient1.cgColor,
                                    UIColor.balanceGradient2.cgColor]
        }
        else{
            gradientLayer.frame = debtCard.bounds
            gradientLayer.colors = [UIColor.debtGradient1.cgColor,
                                    UIColor.debtGradient2.cgColor]
        }
        
        gradientLayer.locations = [0.0, 0.6]
        gradientLayer.cornerRadius = 20.0
        
        return gradientLayer
    }
}
