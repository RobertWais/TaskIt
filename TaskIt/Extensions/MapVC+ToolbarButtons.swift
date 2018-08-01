//
//  MapVC+ToolbarButtons.swift
//  TaskIt
//
//  Created by Robert Wais on 7/25/18.
//

import Foundation
import UIKit

//▲▼✔

extension MapVC {
    //UI For Buttons
    func initialButtons(){
        initialSet()
        secondSet()
        setUpAddBtn()
    }
    
    func initialSet(){
        ////Collapse Button
        collapseButton = TaskButton(color: Constants.Colors.safeRed, cRadius: tempToolBar.frame.height/4, symbol: "-")
        collapseButton.addTarget(self, action: #selector(collapseBar), for: .touchUpInside)
        let collapseButtonItem = UIBarButtonItem(customView: collapseButton)
        collapseButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        
        //Square Button
        squareButton =  TaskButton(color: UIColor.black, cRadius: tempToolBar.frame.height/4, symbol: "☐")
        squareButton.addTarget(self, action: #selector(addShape(sender:)), for: .touchUpInside)
        let squareButtonItem = UIBarButtonItem(customView: squareButton)
        squareButton.tag = 1
        squareButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        circleButton =  TaskButton(color: UIColor.black, cRadius: tempToolBar.frame.height/4, symbol: "○")
        circleButton.addTarget(self, action: #selector(addShape(sender:)), for: .touchUpInside)
        let circleButtonItem = UIBarButtonItem(customView: circleButton)
        circleButton.tag = 0
        circleButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        rectangleButton =  TaskButton(color: UIColor.black, cRadius: tempToolBar.frame.height/4, symbol: "▭")
        rectangleButton.addTarget(self, action: #selector(addShape(sender:)), for: .touchUpInside)
        let rectangleButtonItem = UIBarButtonItem(customView: rectangleButton)
        rectangleButton.tag = 2
        rectangleButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        
        firstBarItems = [collapseButtonItem,spacer,spacer,spacer,rectangleButtonItem,spacer,squareButtonItem,spacer,circleButtonItem]
        tempToolBar.setItems(firstBarItems, animated: true)
        tempToolBar.isHidden = true
        tempToolBar.alpha = 1.0
    }
    
    func setUpAddBtn(){
        addBtn = UIButton(frame: CGRect(x: (view.frame.width - 100), y:(view.frame.height - 100), width: 75, height: 75))
        //Show toolbar
        addBtn.addTarget(self, action: #selector(showToolBar), for: UIControlEvents.touchUpInside)
        addBtn.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40.0)]), for: .normal)
        addBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        addBtn.layer.cornerRadius = addBtn.layer.frame.width/2
        addBtn.layer.masksToBounds = true
        addBtn.backgroundColor = Constants.Colors.baseColor
        view.addSubview(addBtn)
        view.bringSubview(toFront: addBtn)
    }
    
    //MARK: Functions on Toolbars
    @objc func showToolBar(){
        tempToolBar.alpha = 0.0
        tempToolBar.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.addBtn.alpha = 0.0
            self.tempToolBar.alpha = 1.0
            self.addBtn.center.x = (self.view.frame.width)+(self.addBtn.frame.width/2)
        }) { (success) in
            if success{
                self.addBtn.isHidden = true
            }
        }
    }
    
    @objc func collapseBar(){
        addBtn.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.addBtn.alpha = 0.9
            self.tempToolBar.alpha = 0.0
            self.addBtn.center.x = (self.view.frame.width - 50)
        }) { (success) in
            if success{
                self.tempToolBar.isHidden = true
            }
        }
    }
    
    func collapseEditBar(){
        if currentShape.isUserInteractionEnabled == true {
            currentShape.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmBtn.center.y = self.confirmBtn.center.y+100
            self.revertBtn.center.y = self.revertBtn.center.y+100
            self.dPadView.isHidden = true
        }) { (success) in
            print("Yes")
            self.tempToolBar.setItems(self.firstBarItems, animated: true)
            let collapsePos =  self.collapseButton.center.x
            let squarePos = self.squareButton.center.x
            self.collapseButton.center.x = self.collapseButton.center.x + 100
            self.squareButton.center.x = self.squareButton.center.x - 100
            UIView.animate(withDuration: 0.3, animations: {
                self.collapseButton.center.x = collapsePos
                self.squareButton.center.x = squarePos
            })
        }
    }
    
    //Functions for adding shapes
    @objc func addShape(sender: UIButton){
        let num = sender.tag
        currentShape = TaskShape(shape: num)
        imageView.addSubview(currentShape)
        imageView.bringSubview(toFront: currentShape)
        UIView.animate(withDuration: 0.3, animations: {
            self.collapseButton.center.y = self.collapseButton.center.y+100
            self.squareButton.center.y = self.squareButton.center.y+100
        }) { (success) in
            self.tempToolBar.setItems(self.secondBarItems, animated: true)
            let confirmPos =  self.confirmBtn.center.x
            let revertPos = self.revertBtn.center.x
            self.confirmBtn.center.x = self.confirmBtn.center.x + 100
            self.revertBtn.center.x = self.revertBtn.center.x - 100
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmBtn.center.x = confirmPos
                self.revertBtn.center.x = revertPos
                self.dPadView.isHidden = false
            })
        }
    }
    
    
    @objc func extendRight(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width+CGFloat(slider.value), height: currentShape.bounds.height)
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 3, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.1, y: currentShape.center.y-tuple.0 )
    }
    
    @objc func extendUp(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width, height: currentShape.bounds.height+CGFloat(slider.value))
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 0, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.0, y: currentShape.center.y-tuple.1 )
    }
    
    
    @objc func extendDown(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width, height: currentShape.bounds.height+CGFloat(slider.value))
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 1, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.0, y: currentShape.center.y-tuple.1 )
        
    }
    @objc func extendLeft(){
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width+CGFloat(slider.value), height: currentShape.bounds.height)
        let radians:CGFloat = atan2((currentShape.transform.b), (currentShape.transform.a))
        let tuple = getRadians(code: 2, radians: radians)
        currentShape.center = CGPoint(x: currentShape.center.x-tuple.1, y: currentShape.center.y-tuple.0 )
    }
    
   
    
    //Collapse toolbar and if currentShape is already confirmed, dont move it
    //Will change later
    @objc func collapseSecondToolBar(){
        collapseEditBar()
    }
    
     func getToolBarButton(function: Selector,color: UIColor, cRadius: CGFloat, attrString: NSAttributedString ) -> UIButton{
        let button = UIButton(type: .system)
        button.addTarget(self, action: function, for: .touchUpInside)
        button.backgroundColor = color
        button.layer.cornerRadius = cRadius
        button.sizeToFit()
        button.setAttributedTitle(attrString, for: .normal)
        return button
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
    }
}
