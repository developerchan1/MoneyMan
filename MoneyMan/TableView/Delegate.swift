//
//  Delegate.swift
//  MoneyMan
//
//  Created by Chandra on 26/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class Delegate: NSObject, UITableViewDelegate {
 
    weak var delegate : ViewControllerDelegate?

    init(_ delegate : ViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(row: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
