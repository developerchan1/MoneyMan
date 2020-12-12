//
//  DataSource.swift
//  MoneyMan
//
//  Created by Chandra on 26/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class DataSource: NSObject,UITableViewDataSource {
    //save all transaction data
    var arrTransaction = [Transaction]()
    //save filtered transaction data
    var filteredData = [Transaction]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionTableViewCell
        
        let trx = filteredData[indexPath.row]
        
        cell.transactionName.text = trx.name
        cell.transactionDate.text = trx.date
        cell.transactionPrice.text = "IDR \(trx.price)"
        cell.transactionCategory.image = UIImage(named: trx.category)
        
        return cell
    }
        
    func filterTransactionData(_ keyword : String){
        if keyword.isEmpty {
            resetFilteredData();
        }
        else{
            filteredData.removeAll()
            for transaction in arrTransaction {
                if transaction.name.contains(keyword.lowercased()){
                    filteredData.append(transaction)
                }
            }
        }
    }
    
    func resetFilteredData(){
        filteredData = arrTransaction
    }
}
