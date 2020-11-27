//
//  TransactionViewController.swift
//  MoneyMan
//
//  Created by Chandra on 27/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class TransactionViewController: UIViewController, ViewControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tvTransaction: UITableView!
    
    var delegate : Delegate?
    var dataSource : DataSource?
    var selectedTransaction = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = DataSource()
        delegate = Delegate(self)
               
        searchBar.delegate = self
        tvTransaction.delegate = delegate
        tvTransaction.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //show loading alert while fetch data from firestore
        self.showLoadingAlert()
        retrieveTransactionDataFromFirestore()
    }
    
    func retrieveTransactionDataFromFirestore() {
        let uid = Auth.auth().currentUser!.uid
           
        Firestore.firestore().collection("transaction").whereField("uid", isEqualTo: uid).getDocuments() { (document, error) in
            if let error = error {
                print("Error getting documents : \(error)")
            } else {
                var arrTransaction = [Transaction]()
                for data in document!.documents {
                    let userTransaction = data.data()
                    let transactionName = userTransaction["name"] as? String ?? ""
                    let category = userTransaction["category"] as? String ?? ""
                    let date = userTransaction["date"] as? String ?? ""
                    let price = userTransaction["price"] as? Int ?? 0
                    let method = userTransaction["method"] as? String ?? ""
                    let desc = userTransaction["description"] as? String ?? ""
                       
                    let dataArray = Transaction(name: transactionName, date: date, category: category, price: price, method: method, desc: desc)
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
        selectedTransaction = row
        performSegue(withIdentifier: "transactionDetailSegue", sender: self)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionDetailSegue" {
            let dest = segue.destination as! TransactionDetailViewController
            dest.transaction = self.dataSource?.arrTransaction[selectedTransaction]
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource?.resetFilteredData()
        searchBar.text = ""
        searchBar.endEditing(true)
        tvTransaction.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource?.filterTransactionData(searchText)
        tvTransaction.reloadData()
    }
    
}
