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
        cell.transactionPrice.text = printBalance(trx.price)
        cell.transactionCategory.image = UIImage(named: trx.category)

        return cell
    }
    
    func printBalance(_ inputBalance: Int) -> String{
        var balance = inputBalance
        // default return value
        if balance == 0 {
            return "IDR 0"
        }
        
        var outputBalance = ""
        let multiplier = 1000
        while balance > 0 {
            var num = String(balance%multiplier)
            // print '0's
            while num.count < 3 && balance/multiplier > 0 {
                num = "0" + num
            }
            // print '.' separator
            if outputBalance.count > 0{
                outputBalance = "." + outputBalance
            }
            outputBalance = num + outputBalance
            balance /= multiplier
        }
        
        return "IDR " + outputBalance
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
