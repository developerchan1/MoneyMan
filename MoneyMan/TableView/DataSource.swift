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
    
    weak var delegate : ViewControllerDelegate?

    init(_ delegate : ViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.deleteCell(row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionTableViewCell

        let trx = filteredData[indexPath.row]

        cell.transactionName.text = trx.name
        cell.transactionDate.text = trx.date
        Tools.priceTextFormat(cell.transactionPrice,trx)
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
                if transaction.name.lowercased().contains(keyword.lowercased()){
                    filteredData.append(transaction)
                }
            }
        }
    }
    
    func resetFilteredData(){
        filteredData = arrTransaction
    }
}
