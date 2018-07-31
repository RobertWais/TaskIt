//
//  TaskButton.swift
//  TaskIt
//
//  Created by Robert Wais on 7/30/18.
//

import UIKit

class TaskButton: UIButton {

    
    init(color: UIColor, cRadius: CGFloat, symbol: String){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = color
        self.layer.cornerRadius = cRadius
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.sizeToFit()
        let attrString = NSAttributedString(string: symbol, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                         NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)])
       self.setAttributedTitle(attrString, for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
