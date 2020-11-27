//
//  UIUtil.swift
//  MoneyMan
//
//  Created by Chandra on 25/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import Foundation
import UIKit

class UIUtil {
    
    public static func textViewStyle (_ textView : UITextView) {
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        textView.layer.borderWidth = 0.5
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
    }
    
    public static func buttonStyle (_ button : UIButton) {
        button.layer.cornerRadius = 20
        button.layer.backgroundColor = UIColor.colorPrimary.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)!
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    public static func roundedCornerCardStyle(_ card : UIView){
        card.layer.cornerRadius = 20.0
        card.layer.shadowColor = UIColor.lightGray.cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowRadius = 12.0
        card.layer.shadowOpacity = 0.25
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
}
