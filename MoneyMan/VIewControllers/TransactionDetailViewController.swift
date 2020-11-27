//
//  TransactionDetailViewController.swift
//  MoneyMan
//
//  Created by Chandra on 27/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtMethod: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var transactionInfoCard: UIView!
    @IBOutlet weak var transactionDescCard: UIView!
    
    var transaction : Transaction? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = transaction {
            txtPrice.text = "IDR \(data.price)"
            txtName.text = data.name
            txtDate.text = data.date
            txtMethod.text = data.method
            txtDescription.text = data.desc
            imgCategory.image = UIImage(named: data.category)
            
            let backgroundColor = setBackgroundColor(data.category)
            view.layer.backgroundColor = backgroundColor.cgColor
            methodLabel.textColor = backgroundColor
            dateLabel.textColor = backgroundColor
            descLabel.textColor = backgroundColor
            
            //set corner radius and give shadow to the cards
            UIUtil.roundedCornerCardStyle(transactionInfoCard)
            UIUtil.roundedCornerCardStyle(transactionDescCard)
        }
    }
    
    func setBackgroundColor(_ category : String) -> UIColor{
        if category == "Income" {
            return UIColor.backgroundIncome
        }
        
        if category == "Expense" {
            return UIColor.backgroundExpense
        }
        
        if category == "Debt" {
            return UIColor.backgroundDebt
        }
        
        return UIColor.backgroundPaidDebt
    }
}
