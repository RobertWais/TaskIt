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
        })
        alert.addAction(cancel)
        controller.present(alert, animated: true){
            button.isEnabled = true
        }
    }
    
    static func noCompanyId(sender: UIViewController){
        let alert = UIAlertController(title: "Company Doesn't exist",
                                      message: "The company id you entered doesn't exist",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        alert.addAction(cancel)
        sender.present(alert, animated: true){
        }
    }
    
    static func displayKey(uniqueID: String,sender: UIViewController, finished: @escaping ()->()){
        let alert = UIAlertController(title: "Unique ID",
                                      message: "All group members must present this unqiue id when creating an account, \n We suggest recording this id down for future use.",
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
        let alert = UIAlertController(title: "No Such Group",
                                      message: "Please enter in a valid group id",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        
        alert.addAction(cancel)
        sender.present(alert, animated: true)
    }
    
    static func successButFailure(sender: UIViewController){
        let alert = UIAlertController(title: "Sign Up Successful",
                                      message: "Invalid group id. Log in with a valid group id",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        
        alert.addAction(cancel)
        sender.present(alert, animated: true)
    }
    
    static func couldNotDelete(sender: UIViewController){
        let alert = UIAlertController(title: "Delete Unsuccessful",
                                      message: "Could not set this task as completed \n Please try again",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        
        alert.addAction(cancel)
        sender.present(alert, animated: true)
    }
   
    static func couldNotCreate(sender: UIViewController){
        let alert = UIAlertController(title: "Could Not Create Company",
                                      message: "Please try again",
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
        
        alert.addAction(cancel)
        sender.present(alert, animated: true)
    }
    
    
    
}
