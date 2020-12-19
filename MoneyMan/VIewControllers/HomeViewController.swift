//
//  MainViewController.swift
//  MoneyMan
//
//  Created by Chandra on 19/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, ViewControllerDelegate{

    @IBOutlet weak var txtBalance: UILabel!
    @IBOutlet weak var tvTransaction: UITableView!
    
    var delegate : Delegate?
    var dataSource : DataSource?
    var selectedTransaction = -1
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSource = DataSource(self)
        delegate = Delegate(self)
        
        tvTransaction.delegate = delegate
        tvTransaction.dataSource = dataSource
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showLoadingAlert()
        getBalanceAndTransaction()
    }
    
    func getBalanceAndTransaction(){
        retrieveBalanceFromFirestore()
        retrieveTransactionDataFromFirestore()
    }
    
    func retrieveBalanceFromFirestore() {
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("balanceAndDebt")
            .document(uid)
            .getDocument { (document, error) in
            if error == nil{
                if document != nil && document!.exists{
                    if let data = document!.data() {
                        self.txtBalance.text = Tools.printBalance(data["balance"] as! Int)
                    }
                }
            }
        }
    }
    
    func retrieveTransactionDataFromFirestore() {
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("transaction")
            .whereField("uid", isEqualTo: uid)
            .order(by: "date", descending: true)
            .getDocuments() { (document, error) in
            if let error = error {
                print("Error getting documents : \(error)")
            } else {
                var arrTransaction = [Transaction]()
                for data in document!.documents {
                    let userTransaction = data.data()
                    let id = data.documentID
                    let transactionName = userTransaction["name"] as? String ?? ""
                    let category = userTransaction["category"] as? String ?? ""
                    let date = Tools.dateFormat((userTransaction["date"] as! Timestamp).dateValue())
                    let price = userTransaction["price"] as? Int ?? 0
                    let method = userTransaction["method"] as? String ?? ""
                    let desc = userTransaction["description"] as? String ?? ""
                    
                    let dataArray = Transaction(id: id,name: transactionName, date: date, category: category, price: price, method: method, desc: desc)
                    arrTransaction.append(dataArray)
                }
                self.dataSource?.arrTransaction = arrTransaction
                self.dataSource?.filteredData = arrTransaction
                self.tvTransaction.reloadData()
            }
            //hide loading alert while data fetched from firestore
            self.dismissLoadingAlert()
        }
    }
    
    func selectedCell(row: Int) {
        //show transaction detail
        selectedTransaction = row
        performSegue(withIdentifier: "transactionDetailSegue", sender: self)
    }
    
    func deleteCell(row: Int) {
        //show confirmation dialog before delete
        showConfirmationDialog("Delete Transaction Confirmation", "Do you really want to delete this transaction", {
            
            let transaction = (self.dataSource?.arrTransaction[row])!
            self.showLoadingAlert()
            
            //delete transaction
            self.db.collection("transaction")
                .document(transaction.id)
                .delete() { err in
                if let err = err {
                    self.showErrorDialog("Error Message", "\(err.localizedDescription)")
                } else {
                    //update balance and debt amount
                    self.changeBalanceAndDebtInFirestore(transaction.category, transaction.price)
                }
            }
        })
    }
    
    func changeBalanceAndDebtInFirestore(_ transactionCategory : String, _ price : Int){
        let user_uid = (Auth.auth().currentUser?.uid)!
        
        if transactionCategory == "Income" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(Int64(price * -1))
            ])
        }
        else if transactionCategory == "Expense" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(Int64(price))
            ])
        }
        else if transactionCategory == "Debt" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(Int64(price * -1)),
                "debt" : FieldValue.increment(Int64(price * -1))
            ])
        }
        else if transactionCategory == "Paid Debt" {
            db.collection("balanceAndDebt").document(user_uid).updateData([
                "balance" : FieldValue.increment(Int64(price)),
                "debt" : FieldValue.increment(Int64(price))
            ])
        }
        
        getBalanceAndTransaction()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionDetailSegue" {
            let dest = segue.destination as! TransactionDetailViewController
            dest.transaction = self.dataSource?.arrTransaction[selectedTransaction]
        }
    }
    
}
