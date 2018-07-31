//
//  ButtonItem.swift
//  TaskIt
//
//  Created by Robert Wais on 7/30/18.
//

import UIKit

class ButtonItem: UIBarButtonItem {

    
    init(function: Selector, color: UIColor, cRadius: CGFloat, symbol: String,rect: CGRect){
        super.init()
        let button = UIButton(type: .system)
        button.frame = rect
        button.addTarget(self, action: function, for: .touchUpInside)
        button.backgroundColor = color
        button.layer.cornerRadius = cRadius
        button.sizeToFit()
        let attrString = NSAttributedString(string: symbol, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)])
        button.setAttributedTitle(attrString, for: .normal)
        
        self.customView = button
        self.customView?.frame = rect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
