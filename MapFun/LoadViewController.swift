//
//  LoadViewController.swift
//  GoApp
//
//  Created by X on 12/9/16.
//  Copyright © 2016 Brenda Kaing. All rights reserved.
//

import Foundation
import UIKit


class LoadViewController: UIViewController {
    
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var secondIcon: UIImageView!
    @IBOutlet weak var thirdIcon: UIImageView!
    @IBOutlet weak var fourthIcon: UIImageView!
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var TriangleView: TriangleView!
    
    @IBOutlet weak var GoButton: UIButton!
    @IBOutlet weak var LoadButton: UIButton!
    
    @IBOutlet weak var firstLine: UILabel!
    @IBOutlet weak var secondLine: UILabel!
    
    @IBOutlet weak var G: UILabel!  //These are floaties
    @IBOutlet weak var O: UILabel!
    @IBOutlet weak var GO: UILabel!
    @IBOutlet weak var GO2: UILabel!
    
    override func viewDidLoad() {
        firstIcon.image = UIImage(named: "Drink")
        secondIcon.image = UIImage(named: "Camera")
        thirdIcon.image = UIImage(named: "Music")
        fourthIcon.image = UIImage(named: "Bike")
//        moving()
        movingG()
        movingO()
        movingGO()
        movingGO2()
        fadeIn()
        TriangleView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.5, delay: 3.5, options: .curveEaseOut, animations: {
            self.LoadButton.fadeIn(delay: 4.5)
            self.G.fadeIn(delay: 4.5)
            self.O.fadeIn(delay: 4.5)
            self.GO.fadeIn(delay: 4.5)
            self.GO2.fadeIn(delay: 4.5)

            var TriangleViewFrame = self.TriangleView.frame
            TriangleViewFrame.origin.y += TriangleViewFrame.size.height
            var TopViewFrame = self.TopView.frame
            TopViewFrame.origin.y -= TopViewFrame.size.height
            self.TriangleView.frame = TriangleViewFrame
            self.TopView.frame = TopViewFrame
        }, completion: { finished in
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func fadeIn(){
        self.GoButton.fadeIn(delay: 0.1)
        self.firstLine.fadeIn(delay: 0.2)
        self.secondLine.fadeIn(delay: 0.3)
        self.firstIcon.fadeIn(delay: 0.4)
        self.secondIcon.fadeIn(delay: 0.5)
        self.thirdIcon.fadeIn(delay: 0.6)
        self.fourthIcon.fadeIn(delay: 0.7)
    }
    


//    func moving() {
//        for _ in 0...5 {
//            let square = UIView()
//            square.frame = CGRect(x: 50, y: 1000, width: 15, height: 15)
//            square.backgroundColor = UIColor.lightGray
//            self.view.addSubview(square)
//            let randomYOffset = CGFloat( arc4random_uniform(150))
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: 16,y: 25 ))
//            path.addCurve(to: CGPoint(x: 401, y: 13 + randomYOffset), controlPoint1: CGPoint(x: 136, y: 22), controlPoint2: CGPoint(x: 178, y: 24))
//            let anim = CAKeyframeAnimation(keyPath: "position")
//            anim.path = path.cgPath
//            anim.rotationMode = kCAAnimationRotateAuto
//            anim.repeatCount = Float.infinity
//            anim.duration = Double(arc4random_uniform(40)+30) / 10
//            anim.timeOffset = Double(arc4random_uniform(290))
//            square.layer.add(anim, forKey: "animate position along path")
//        }
//    }
    

    func movingG () {
        for _ in 0...5 {
            let G = UIView()
            self.G.text = "GO!"
            self.G.font = UIFont.systemFont(ofSize: 20)
            self.G.textColor = UIColor.lightGray
            self.G.sizeToFit()
            view.addSubview(G)
            let randomYOffset = CGFloat( arc4random_uniform(150))
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 16,y: 25 + randomYOffset))
            path.addCurve(to: CGPoint(x: 401, y: 13 + randomYOffset), controlPoint1: CGPoint(x: 136, y: 22 + randomYOffset), controlPoint2: CGPoint(x: 178, y: 24 + randomYOffset))
            let anim = CAKeyframeAnimation(keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40)+30) / 10
            anim.timeOffset = Double(arc4random_uniform(290))
            anim.beginTime = CACurrentMediaTime() + 1.0
            self.G.layer.add(anim, forKey: "animate position along path")
        }
    }
    
    
    func movingO () {
        for _ in 0...5 {
            let O = UIView()
            self.O.text = "GO!"
            self.O.font = UIFont.systemFont(ofSize: 20)
            self.O.textColor = UIColor.yellow
            self.O.sizeToFit()
            view.addSubview(O)
            let randomYOffset = CGFloat( arc4random_uniform(150))
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 16,y: 150 + randomYOffset))
            path.addCurve(to: CGPoint(x: 401, y: 43 + randomYOffset), controlPoint1: CGPoint(x: 136, y: 42 + randomYOffset), controlPoint2: CGPoint(x: 178, y: 144 + randomYOffset))
            let anim = CAKeyframeAnimation(keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40)+30) / 10
            anim.timeOffset = Double(arc4random_uniform(290))
            anim.beginTime = CACurrentMediaTime() + 1.0

            self.O.layer.add(anim, forKey: "animate position along path")
        }
    }
    
    func movingGO () {
        for _ in 0...5 {
            let GO = UIView()
            self.GO.text = "GO!"
            self.GO.font = UIFont.systemFont(ofSize: 20)
            self.GO.textColor = UIColor.lightGray
            self.GO.sizeToFit()
            view.addSubview(GO)
            let randomYOffset = CGFloat( arc4random_uniform(150))
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 16,y: 75 + randomYOffset))
            path.addCurve(to: CGPoint(x: 401, y: 370 + randomYOffset), controlPoint1: CGPoint(x: 136, y: 62 + randomYOffset), controlPoint2: CGPoint(x: 178, y: 224 + randomYOffset))
            let anim = CAKeyframeAnimation(keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40)+30) / 10
            anim.timeOffset = Double(arc4random_uniform(290))
            anim.beginTime = CACurrentMediaTime() + 1.0
            self.GO.layer.add(anim, forKey: "animate position along path")
        }
    }
    
    func movingGO2 () {
        for _ in 0...5 {
            _ = UIView()
            self.GO2.text = "GO!"
            self.GO2.font = UIFont.systemFont(ofSize: 20)
            self.GO2.textColor = UIColor.yellow
            self.GO2.sizeToFit()
            view.addSubview(GO)
            let randomYOffset = CGFloat( arc4random_uniform(150))
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 16,y: 75 + randomYOffset))
            path.addCurve(to: CGPoint(x: 701, y: 570 + randomYOffset), controlPoint1: CGPoint(x: 536, y: 362 + randomYOffset), controlPoint2: CGPoint(x: 478, y: 424 + randomYOffset))
            let anim = CAKeyframeAnimation(keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40)+30) / 10
            anim.timeOffset = Double(arc4random_uniform(290))
            anim.beginTime = CACurrentMediaTime() + 1.0
            self.GO2.layer.add(anim, forKey: "animate position along path")
        }
    }
    
    
}
