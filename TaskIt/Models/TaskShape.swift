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
    var key: String?
    var type = 0
    var previous: CGFloat = 0
    weak var turnDelegate: TurnDelegate?
    //Default Creation
    init(shape: Int, view: UIView?){
        if shape == 2{
            super.init(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 50))
        }else{
           super.init(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
        }
        self.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 0.9)
        self.initGestures()
        self.isUserInteractionEnabled = true
        self.type = shape
        if shape == 0 {
            self.layer.cornerRadius = self.frame.height/2
        }
        self.backgroundColor = UIColor(red: 255/255, green: 220/255, blue: 51/255, alpha: 0.9)
    }
    
    //Read from Firebase
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    func disableInteraction(){
        for gesture in gestureRecognizers! {
            self.removeGestureRecognizer(gesture)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCornerRadius(){
        self.layer.cornerRadius = self.frame.height/2
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
        self.transform = self.transform.rotated(by: recognizer.rotation)
        
        let turn = atan2((self.transform.b), (self.transform.a))
        turnDelegate?.didTurn(turn: turn)
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
        self.bounds = CGRect(x: 0, y: 0, width: self.bounds.width*recognizer.scale, height: self.bounds.height*recognizer.scale)
        recognizer.scale = 1.0
        if type == 0 {
            updateCornerRadius()
        }
    }
    
    @objc func didTap(recognizer: UITapGestureRecognizer){
    }
    
    
    
    
    
}
