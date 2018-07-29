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
    
    var curRotation: CGFloat = 0.0{
        didSet{
            updateTransform()
        }
    }
    var curTranslation: (CGFloat, CGFloat) = (0.0,0.0){
        didSet{
            updateTransform()
        }
    }
    var curScaleX: CGFloat = 1.0
    var curScaleY: CGFloat = 1.0 {
        didSet{
            updateTransform()
        }
    }
    
    func updateTransform(){
//        var transforms = CGAffineTransform(rotationAngle: CGFloat.pi)
//        transforms = transforms.scaledBy(x: 3, y: 3)
//        self.square.transform = transforms
//        self.square.alpha = 0.2
//        var transforms = CGAffineTransform()
//        transforms = transforms.scaledBy(x: curScaleY, y: curScaleX)
//        transforms = transforms.rotated(by: curRotation)
//        self.transform = transforms
       
        var transforms = CGAffineTransform(scaleX: curScaleX, y: curScaleY)
        transforms = transforms.rotated(by: curRotation)
        self.transform = transforms
        self.center.x = curTranslation.0
        self.center.y = curTranslation.1
        
       
        
    }
    
    
    
    
    //Default Creation
    init(){
        super.init(frame: CGRect(x: 200.0, y: 300.0, width: 100, height: 100))
        self.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 0.9)
        self.initGestures()
        self.isUserInteractionEnabled = true
    }
    
    //Read from Firebase
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    func disableInteraction(){
        self.isUserInteractionEnabled = false
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
//        self.transform = self.transform.rotated(by: recognizer.rotation)
        curRotation = recognizer.rotation
//         Some sort of callback to reset this after curRotation is set
//        recognizer.rotation = 0.0
    }
    
    
    @objc func didPan(recognizer: UIPanGestureRecognizer){
        self.superview!.bringSubview(toFront: self)
        var translation = recognizer.translation(in: self)
        translation = translation.applying(self.transform)
        curTranslation = (self.center.x + translation.x,self.center.y + translation.y)
        
       recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func didPinch(recognizer: UIPinchGestureRecognizer){
//        self.transform = self.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        
        
        curScaleY = recognizer.scale
        curScaleX = recognizer.scale
//        recognizer.scale = 1.0
    }
    
    @objc func didTap(recognizer: UITapGestureRecognizer){
    }
}

struct Num {
    var x: CGFloat = 0
}
