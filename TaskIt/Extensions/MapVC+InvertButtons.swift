//
//  MapVC+InvertButtons.swift
//  TaskIt
//
//  Created by Robert Wais on 7/27/18.
//

import Foundation
import UIKit

extension MapVC {
    func secondSet(){
        
        ////Slider Button
        slider = UISlider(frame: CGRect(x: 0, y: 0, width: tempToolBar.frame.width/4, height: tempToolBar.frame.height/2))
        slider.tintColor = UIColor.black
        slider.setValue(2, animated: false)
        slider.minimumValue = 2
        slider.maximumValue = 70
        slider.addTarget(self, action: #selector(draggedSlider), for: .valueChanged)
        let sliderBtnItem = UIBarButtonItem(customView: slider)
        
        ////Confirm Button
        confirmBtn = TaskButton(color: Constants.Colors.baseColor, cRadius: tempToolBar.frame.height/4, symbol: "✓")
        confirmBtn.addTarget(self, action: #selector(confirmShape), for: .touchUpInside)
        let confirmButtonItem = UIBarButtonItem(customView: confirmBtn)
        confirmButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        
        //RevertBtn
        revertBtn = TaskButton(color: Constants.Colors.safeRed, cRadius: tempToolBar.frame.height/4, symbol: "-")
        revertBtn.addTarget(self, action: #selector(collapseSecondToolBar), for: .touchUpInside)
        let revertButtonItem = UIBarButtonItem(customView: revertBtn)
        revertButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        setUpDisplayButtons()
        
        
        //PLUS Minus/Button
            let freezeButtonItem = UIBarButtonItem(customView: freezeBtn)
        freezeButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        //Set ToolBar
           secondBarItems = [revertButtonItem,spacer,sliderBtnItem,spacer,freezeButtonItem,spacer,confirmButtonItem]
        
        ///SET Functions
        
        dPadView.upBtn.addTarget(self, action: #selector(extendUp), for: .touchUpInside)
        dPadView.downBtn.addTarget(self, action: #selector(extendDown), for: .touchUpInside)
        dPadView.leftBtn.addTarget(self, action: #selector(extendLeft), for: .touchUpInside)
        dPadView.rightBtn.addTarget(self, action: #selector(extendRight), for: .touchUpInside)
        
        dPadView.invertUpBtn.addTarget(self, action: #selector(invertUp), for: .touchUpInside)
        dPadView.invertDownBtn.addTarget(self, action: #selector(invertDown), for: .touchUpInside)
        dPadView.invertLeftBtn.addTarget(self, action: #selector(invertLeft), for: .touchUpInside)
        dPadView.invertRightBtn.addTarget(self, action: #selector(invertRight), for: .touchUpInside)
    }
    
    
    //Inverted Button Actions
    @objc func invertRight(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width-CGFloat(slider.value), height: currentShape.bounds.height)
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 2, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.1, y: currentShape.center.y-tuple.0 )
    }
    
    @objc func invertUp(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width, height: currentShape.bounds.height-CGFloat(slider.value))
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 1, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.0, y: currentShape.center.y-tuple.1)
    }
    @objc func invertDown(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width, height: currentShape.bounds.height-CGFloat(slider.value))
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 0, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.0, y: currentShape.center.y-tuple.1 )
    }
    
    @objc func invertLeft(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width-CGFloat(slider.value), height: currentShape.bounds.height)
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 3, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.1, y: currentShape.center.y-tuple.0 )
    }
    
    //Slider Actions
    @objc func draggedSlider(){
        print("Value: \(slider.value)")
    }
    
    func getRadians(code: Int,radians: CGFloat)->(CGFloat,CGFloat){
        var returnTuple: (CGFloat,CGFloat)
        switch code{
        case 0 :
            returnTuple = (-sin(radians),cos(radians))
        case 1 :
            returnTuple = (sin(radians),-cos(radians))
        case 2 :
            returnTuple = (sin(radians), cos(radians))
        case 3 :
            returnTuple = (-sin(radians),-cos(radians))
        default :
            print("Error: retrieving radions")
            return (0,0)
            
        }
        
        return (returnTuple.0*(CGFloat(slider.value)/2),returnTuple.1*(CGFloat(slider.value)/2))
    }
    @objc func freezeScoll(){
        if freeze == 0{
            freezeView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.bounds.width, height: imageView.bounds.height))
            freezeView.backgroundColor = Constants.Colors.freezeBlueLight
            
            imageView.addSubview(freezeView)
            imageView.sendSubview(toBack: freezeView)
            scrollView.isScrollEnabled = false
            freeze = 1
            return
        }
        scrollView.isScrollEnabled = true
        freezeView.removeFromSuperview()
        freeze = 0
    }
    
    func setUpDisplayButtons(){
        freezeBtn = TaskButton(color: Constants.Colors.freezeBlue, cRadius: tempToolBar.frame.height/4, symbol: "❆")
        freezeBtn.addTarget(self, action: #selector(freezeScoll), for: .touchUpInside)        
    }
}


