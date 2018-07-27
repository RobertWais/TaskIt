//
//  testButtn.swift
//  TaskIt
//
//  Created by Robert Wais on 7/27/18.
//

import UIKit

class testButtn: UIBarButtonItem {

    
    init(btn: UIButton){
        super.init()
        self.customView = btn
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
