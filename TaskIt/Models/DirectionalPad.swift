//
//  DirectionalPad.swift
//  TaskIt
//
//  Created by Robert Wais on 7/26/18.
//

import UIKit

class DirectionalPad: UIView {
    
    var  baseView: UIView!
    var toolBar: UIToolbar!
    var upBtn: UIButton!
    var invertUpBtn: UIButton!
    
    var rightBtn: UIButton!
    var invertRightBtn: UIButton!
    
    var downBtn: UIButton!
    var invertDownBtn: UIButton!
    
    var leftBtn: UIButton!
    var invertLeftBtn: UIButton!
    
    var invertBtn: UIButton!
    
    var regularBtns = [UIButton]()
    var invertBtns = [UIButton]()
    var allSections = [[UIButton]]()
    
    var current = 0
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    init(view: UIView, toolbar: UIToolbar){
        
        super.init(frame: CGRect(x: view.frame.width - (100+10), y: (view.frame.height-(toolbar.frame.height+5+100)), width: 100, height: 100))
        self.toolBar = toolbar
        self.baseView = view
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.layer.cornerRadius = self.frame.width/6
        self.layer.masksToBounds = true
        invertBtn = makeButton(symbol: "◉", x: (self.frame.height/3), y:(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        invertBtn.addTarget(self, action: #selector(invert), for: .touchUpInside)
        regularButtons()
        regularBtns = [upBtn,rightBtn,downBtn,leftBtn]
        invertBtns = [invertUpBtn,invertRightBtn,invertDownBtn,invertLeftBtn]
        allSections = [regularBtns,invertBtns]
        
        let swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(recognizer:)))
        swipeLeftGR.direction = .left
        self.addGestureRecognizer(swipeLeftGR)
        
        let swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(recognizer:)))
        swipeRightGR.direction = .right
        self.addGestureRecognizer(swipeRightGR)
    }
    
    @objc func swipeLeft(recognizer: UISwipeGestureRecognizer){
        UIView.animate(withDuration: 0.2 , animations: {
            self.frame = CGRect(x: 10, y: self.frame.minY, width: 100, height: 100)
        })
    }
    
    @objc func swipeRight(recognizer: UISwipeGestureRecognizer){
        UIView.animate(withDuration: 0.2 , animations: {
            self.frame = CGRect(x: self.baseView.frame.width - (100+10), y: (self.baseView.frame.height-(self.toolBar.frame.height+5+100)), width: 100, height: 100)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeButton(symbol: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)->UIButton{
        let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        button.backgroundColor = UIColor.clear
        button.setAttributedTitle(NSAttributedString(string: symbol, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black,
                                                                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 35.0)]), for: .normal)
        self.addSubview(button)
        return button
    }
    
    private func regularButtons(){
        upBtn = makeButton(symbol: "▲", x: self.frame.width/3, y: 0, width: self.frame.width/3, height: self.frame.height/3)
        
        leftBtn = makeButton(symbol: "◀︎", x: 0, y:(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        
        downBtn = makeButton(symbol: "▼", x: self.frame.width/3, y: (self.frame.height)-(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        
        rightBtn = makeButton(symbol: "▶︎", x: (self.frame.height)-(self.frame.height/3), y:(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        
        invertUpBtn = makeButton(symbol: "▼", x: self.frame.width/3, y: 0, width: self.frame.width/3, height: self.frame.height/3)
        invertUpBtn.isHidden = true
        invertLeftBtn = makeButton(symbol: "▶︎", x: 0, y:(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        invertLeftBtn.isHidden = true
        invertDownBtn = makeButton(symbol: "▲", x: self.frame.width/3, y: (self.frame.height)-(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        invertDownBtn.isHidden = true
        invertRightBtn = makeButton(symbol: "◀︎", x: (self.frame.height)-(self.frame.height/3), y:(self.frame.height/3), width: self.frame.width/3, height: self.frame.height/3)
        invertRightBtn.isHidden = true
        
    }
    @objc func invert(){
        var currentShown = [UIButton]()
        current == 0 ? (currentShown = regularBtns) : (currentShown = invertBtns)
        
        
        currentShown.map {$0.isHidden=true}
        var addBtns = [UIButton]()
        addBtns = allSections[(current+1)%2]
        addBtns.map {$0.isHidden=false}
        current = (current+1)%2
    }

}
