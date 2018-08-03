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
    
    static func fillOutFields(controller: UIViewController, button: UIButton){
        let alert = UIAlertController(title: "",
                                      message: "Must fill out all the fields",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            print("Alert color: \(String(describing: alert.view.backgroundColor))")
        })
        alert.addAction(cancel)
        controller.present(alert, animated: true){
            button.isEnabled = true
        }
    }
    
    static func noCompanyId(sender: UIViewController, button: UIButton){
        let alert = UIAlertController(title: "Company Doesn't exist",
                                      message: "The company id you entered doesn't exist",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        alert.addAction(cancel)
        sender.present(alert, animated: true){
            button.isEnabled = true
        }
    }
    
    static func displayKey(uniqueID: String,sender: UIViewController, finished: @escaping ()->()){
        let alert = UIAlertController(title: "Unique ID",
                                      message: "All employees must present this unqiue id \n \n There is no way to retrieve this ID after this message\n You will not be able to continue until you copy the identifier",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            finished()
        })
        var textField: UITextField!
        alert.addTextField { (TextField) in
            textField = TextField
            textField.text = uniqueID
            textField.isUserInteractionEnabled = true
            
        }
        
        alert.addAction(cancel)
        sender.present(alert, animated: true)
    }
    
    static func companyDoesNotExist(sender: UIViewController){
        let alert = UIAlertController(title: "No Such Company",
                                      message: "Please enter in a valid company",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        
        alert.addAction(cancel)
        sender.present(alert, animated: true)
    }
    
   
    
    
}
