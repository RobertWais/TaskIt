//
//  MapVC+ToolbarButtons.swift
//  TaskIt
//
//  Created by Robert Wais on 7/25/18.
//

import Foundation
import UIKit


extension MapVC {
    
    
    func initialSet(){
        ////Collapse Button
        collapseButton = UIButton(type: .system)
        collapseButton.addTarget(self, action: #selector(collapseBar), for: UIControlEvents.touchUpInside)
        collapseButton.setTitle("-", for: .normal)
        collapseButton.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        collapseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        collapseButton.layer.borderColor = UIColor.white.cgColor
        collapseButton.layer.borderWidth = 1.0
        collapseButton.layer.cornerRadius = 3.0
        collapseButton.layer.masksToBounds = true
        collapseButton.sizeToFit()
        let collapseButtonItem = UIBarButtonItem(customView: collapseButton)
        collapseButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        
        //Square Button
        squareButton = UIButton(type: .system)
        squareButton.backgroundColor = UIColor.black
        squareButton.setAttributedTitle(NSAttributedString(string: "☐", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]), for: .normal)
        squareButton.layer.borderColor = UIColor.white.cgColor
        squareButton.layer.borderWidth = 1.0
        squareButton.layer.cornerRadius = 3.0
        squareButton.layer.masksToBounds = true
        squareButton.sizeToFit()
        let squareButtonItem = UIBarButtonItem(customView: squareButton)
        squareButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)

        tempToolBar.setItems([squareButtonItem,spacer,spacer, collapseButtonItem], animated: true)
        tempToolBar.isHidden = true
        tempToolBar.alpha = 0.9
    }
    
    func setUpAddBtn(){
        addBtn = UIButton(frame: CGRect(x: (view.frame.width - 100), y:(view.frame.height - 100), width: 75, height: 75))
        //Show toolbar
        addBtn.addTarget(self, action: #selector(showToolBar), for: UIControlEvents.touchUpInside)
        addBtn.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40.0)]), for: .normal)
        addBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        addBtn.layer.cornerRadius = addBtn.layer.frame.width/2
        addBtn.layer.masksToBounds = true
        addBtn.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 0.9)
        view.addSubview(addBtn)
        view.bringSubview(toFront: addBtn)
    }
    
    @objc func showToolBar(){
        tempToolBar.alpha = 0.0
        tempToolBar.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.addBtn.alpha = 0.0
            self.tempToolBar.alpha = 0.9
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
    
    func initialButtons(){
        initialSet()
        setUpAddBtn()
    }
    
    
    
}
