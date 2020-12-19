//
//  Tools.swift
//  MoneyMan
//
//  Created by Chandra on 18/12/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            if url == nil{
                print("URL is nil. Can't set image")
            }
            else{
                //get updated url
                let imgName = url!.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending("/\(imgName)")
                let updatedUrl = URL.init(fileURLWithPath: localPath!)
                // set image based on url
                if let data = try? Data(contentsOf: updatedUrl) {
                    print("data: \(data)")
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
    
            }
        }
    }
}

extension UIViewController {
    func showLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissLoadingAlert() {
        dismiss(animated: false, completion: nil)
    }
    
    func showErrorDialog(_ title : String, _ msg : String){
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func showConfirmationDialog(_ title : String, _ msg : String, _ actionHandler : @escaping ()->()) {
        //show alert before logout
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
            (action) in
            actionHandler()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessDialog(_ title : String, _ subtitle : String, _  alertButtons : [String:()->()]){
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
        
        for (title, action) in alertButtons {
            alert.addButton(title, action: action)
        }
        
        alert.showSuccess(title, subTitle: subtitle)
    }
}

struct Tools {
    public static func dateFormat(_ date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        return dateFormatter.string(from: date)
    }
    
    public static func priceTextFormat(_ txtPrice : UILabel, _ transaction :Transaction){
        
        txtPrice.text = self.printBalance(transaction.price)
        if transaction.category == "Income" || transaction.category == "Paid Debt" {
            txtPrice.text = "+\(txtPrice.text!)"
            txtPrice.textColor = UIColor.colorPrimary
        }
        else if transaction.category == "Expense" || transaction.category == "Debt" {
            txtPrice.text = "-\(txtPrice.text!)"
            txtPrice.textColor = UIColor.debtGradient2
        }
    }
    
    public static func printBalance(_ inputBalance: Int) -> String{
         var balance = inputBalance
         var outputBalance = ""
         let multiplier = 1000
         
         // default return value
         if balance == 0 {
             return "IDR 0"
         }
         
         //if negative, force to positive value
         if balance < 0 {
             balance = balance * -1
         }
         
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
         
         if inputBalance < 0 {
              return "IDR -" + outputBalance
         }
         return "IDR " + outputBalance
     }
}

