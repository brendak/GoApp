//
//  triangleViewController.swift
//  GoApp
//
//  Created by X on 12/9/16.
//  Copyright © 2016 Brenda Kaing. All rights reserved.
//

import UIKit

class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 0.1), y: rect.minY / 9.0))
        context.addLine(to: CGPoint(x: rect.maxX / -0.9, y: rect.maxY / 9.0))
        context.closePath()
        
//        context.setFillColor(red: 0.31, green: 0.87, blue: 0.80, alpha: 1.00)
//        context.setFillColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
//        context.setFillColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        context.setFillColor(red:0.41, green:0.76, blue:0.62, alpha:1.0)

        context.fillPath()
        


    }
}
