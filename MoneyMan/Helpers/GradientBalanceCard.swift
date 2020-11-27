//
//  GradientBalanceCard.swift
//  MoneyMan
//
//  Created by Chandra on 24/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

@IBDesignable
class GradientBalanceCard: UIView {

    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor,    UIColor.green.cgColor, UIColor.blue.cgColor]
        gradientLayer.locations = [0.0, 0.6, 0.8]
        
        //define frame
        gradientLayer.frame = self.
        
        //insert the gradient layer to the view layer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
