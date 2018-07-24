//
//  Alerts.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import Foundation
import UIKit


struct Alerts{
    
    static func simpleAlert(err: Error, controller: UIViewController){
        
            let alert = UIAlertController(title: "Error",
                                          message: err.localizedDescription,
                                          preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            })
            alert.addAction(cancel)
            controller.present(alert, animated: true, completion: nil)
        
    }
    
    
}
