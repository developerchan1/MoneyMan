//
//  TransactionTableViewCell.swift
//  MoneyMan
//
//  Created by Handika Limanto on 11/12/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionPrice: UILabel!
    @IBOutlet weak var transactionCategory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
