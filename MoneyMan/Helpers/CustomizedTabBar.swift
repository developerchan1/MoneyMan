//
//  CustomizedTabBar.swift
//  MoneyMan
//
//  Created by Chandra on 23/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit

class CustomizedTabBar: UITabBar {
    
    private var shapeLayer : CALayer?

    override func draw(_ rect: CGRect) {
        addShape();
    }
    
    private func addShape(){
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else{
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath{
        let radius : CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth  = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - 2 * radius), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: degToRadian(number: 180), endAngle: degToRadian(number: 0), clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 35
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }
    
    private func degToRadian(number : CGFloat) -> CGFloat{
         return number * .pi / 180
    }
    
}
