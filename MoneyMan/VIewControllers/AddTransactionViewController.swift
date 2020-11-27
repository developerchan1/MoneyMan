//
//  AddTransactionViewController.swift
//  MoneyMan
//
//  Created by Chandra on 20/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import iOSDropDown
import FirebaseFirestore
import Firebase
import SCLAlertView

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var transactionName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var categoryDrop: DropDown!
    @IBOutlet weak var methodDrop: DropDown!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var transactionCategory:String? = nil
    var transactionMethod:String? = nil
    var todaysDate:String? = nil
    
    let date = Date()
    let dateFormatter = DateFormatter()
    let db = Firestore.firestore()
    let user_uid:String = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dropdown details
        categoryDrop.optionArray = ["Expense", "Income", "Debt", "Paid Debt"]
        methodDrop.optionArray = ["Cash", "Credit", "Digital Wallets", "Debit", "Checks"]
        
        //show-hide dropdown
        categoryDrop.showList()
        categoryDrop.hideList()
        
        methodDrop.showList()
        methodDrop.hideList()
        
        //get selected item name from dropdown
        categoryDrop.didSelect(completion: {(selectedText , index ,id) in self.transactionCategory = selectedText});
        methodDrop.didSelect(completion: {(selectedText, index, id) in self.transactionMethod = selectedText});
        
        //date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        todaysDate =  dateFormatter.string(from: date)
        
        //set text view style
        UIUtil.textViewStyle(txtDesc)
        
        //set button style
        UIUtil.buttonStyle(btnConfirm)
    }
    
    
    
    @IBAction func confirm(_ sender: Any) {
        if inputValid() {
            addTransactionToFirestore()
        }
    }
    
    func inputValid() -> Bool{
        if transactionName.text == "" {
            showErrorDialog("Error Message","Transaction name must be filled")
            return false
        }
        
        if transactionCategory == nil {
            showErrorDialog("Error Message","Category must be selected")
            return false
        }
        
        if transactionMethod == nil {
            showErrorDialog("Error Message","Method must be selected")
            return false
        }
        
        guard Int(txtPrice.text!) != nil else {
            showErrorDialog("Error Message","Price must be a number")
            return false
        }
        
        if txtDesc.text.count < 8 {
            showErrorDialog("Error Message","Description must be at least 8 characters")
            return false
        }
        
        return true
    }
    
    func addTransactionToFirestore(){
        db.collection("transaction").addDocument(data: [
        "uid" : user_uid,
        "date" : todaysDate!,
        "name" : transactionName.text!,
        "category" : transactionCategory!,
        "method" : transactionMethod!,
        "price" : Int(txtPrice.text!)!,
        "description" : txtDesc.text!]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.changeBalanceAndDebtInFirestore()
            }
        }
    }
    
    func changeBalanceAndDebtInFirestore(){
        if transactionCategory == "Income" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(Int64(txtPrice.text!)!)
            ])
        }
        else if transactionCategory == "Expense" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(-Int64(txtPrice.text!)!)
            ])
        }
        else if transactionCategory == "Debt" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(Int64(txtPrice.text!)!),
                "debt" : FieldValue.increment(Int64(txtPrice.text!)!)
            ])
        }
        else if transactionCategory == "Paid Debt" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(-Int64(txtPrice.text!)!),
                "debt" : FieldValue.increment(-Int64(txtPrice.text!)!)
            ])
        }
        showSuccessDialog()
    }
    
    func showErrorDialog(_ title : String, _ msg : String){
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessDialog(){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleTop: CGFloat(50),
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 24)!,
            kTextFont: UIFont(name: "HelveticaNeue-Light", size: 15)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            contentViewCornerRadius: CGFloat(20),
            buttonCornerRadius: CGFloat(8)
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Add Another Transaction") {
            self.clearAllField()
        }

        alert.addButton("Back to Main") {
            self.performSegue(withIdentifier: "tabControllerSegue", sender: self)
        }
        
        alert.showSuccess("Success", subTitle: "This transaction have been added to the transaction list.")
    }
    
    func clearAllField(){
        transactionName.text = ""
        txtPrice.text = ""
        txtDesc.text = ""
        categoryDrop.text = ""
        methodDrop.text = ""
        categoryDrop.selectedIndex = -1
        methodDrop.selectedIndex = -1
    }
}

