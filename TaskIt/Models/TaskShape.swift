//
//  TaskShape.swift
//  TaskIt
//
//  Created by Robert Wais on 7/25/18.
//

import Foundation
import UIKit

class TaskShape: UIView {
    var rotated = 0
    init(){
        super.init(frame: CGRect(x: 200.0, y: 300.0, width: 100, height: 100))
        self.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 0.9)
        self.initGestures()
        self.isUserInteractionEnabled = true
//        setTranslatesAutoresizingMaskIntoConstraints:YES
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initGestures(){
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(didPan(recognizer:)))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(didTap(recognizer:)))
        self.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(recognizer:)))
        self.addGestureRecognizer(pinchGesture)
        
        let rotationGR = UIRotationGestureRecognizer(target: self, action:#selector(didRotate(recognizer:)))
        addGestureRecognizer(rotationGR)
    }
    
    @objc func didRotate(recognizer: UIRotationGestureRecognizer){
        rotated = 1
        
        print("recognizer rotation: \(recognizer.rotation)")
        self.transform = self.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0.0
    }
    
    
    @objc func didPan(recognizer: UIPanGestureRecognizer){
        self.superview!.bringSubview(toFront: self)
        var translation = recognizer.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func didPinch(recognizer: UIPinchGestureRecognizer){
        self.transform = self.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    @objc func didTap(recognizer: UITapGestureRecognizer){
        self.translatesAutoresizingMaskIntoConstraints = true
        let transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.transform = transform
        print("Tapped")
    }
}
