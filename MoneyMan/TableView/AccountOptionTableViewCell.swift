//
//  AccountOptionTableViewCell.swift
//  MoneyMan
//
//  Created by Handika Limanto on 14/12/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class AccountOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    var accountOption = AccountOption("", "")
    
    func setAccountOption(_ accountOption: AccountOption) {
        optionName.text = accountOption.name
        optionImage.image = UIImage(named: accountOption.icon)
    }
}
