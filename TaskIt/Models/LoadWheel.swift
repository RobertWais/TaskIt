//
//  LoadWheel.swift
//  TaskIt
//
//  Created by Robert Wais on 7/31/18.
//

import UIKit

class LoadWheel: UIActivityIndicatorView {

    
    
    init(view: UIView){
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.center = view.center
        self.hidesWhenStopped = true
        self.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(self)
        self.startAnimating()
    }
    
    required init(coder: NSCoder) {
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
