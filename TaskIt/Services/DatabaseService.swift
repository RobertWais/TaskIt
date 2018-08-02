//
//  DatabaseService.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import Foundation
import FirebaseDatabase

//△▭○
struct DatabaseService {
    
    private static let mainRef = Database.database().reference()
    static let companyRef = mainRef.child("company").child(TaskUser.current.companyID)

    static func createCompany(name: String, sender: UIViewController,completion: @escaping (String?)->()){
        let ref = Database.database().reference().child("company").childByAutoId()
        let companyInfo = ["name" : name,
                           "imageURL" : ""]
        ref.setValue(companyInfo) { (error, ref) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: sender)
                completion(nil)
            }else{
                    completion(ref.key)
            }
        }
    }
    
    static func setCompanyURL(id: String, url: String, completion: @escaping (Error?)->()){
        let ref = Database.database().reference().child("company").child(id)
        let updateDict = ["imageURL": url]
        ref.updateChildValues(updateDict) { (error, _) in
            completion(error)
        }
    }
    
    static func makeAPost(task: [String: Any],sender: UIViewController, completion: @escaping (Bool)->()){
        updateArryOfTasks(task: task, sender: sender) { (error, key) in
            if let err = error {
                Alerts.simpleAlert(err: err, controller: sender)
                completion(false)
                return
            }
            updateUser(key: key, title: task["title"] as! String, completion: { (error) in
                print("Error: \(String(describing: error))")
                if let err=error {
                    Alerts.simpleAlert(err: err, controller: sender)
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    static func updateArryOfTasks(task: [String: Any],sender: UIViewController, completion: @escaping (Error?,String)->()){
        let ref = companyRef.child("currentTasks").childByAutoId()
        ref.setValue(task) { (error, dbRef) in
            if let err = error {
                completion(err, "")
                return
            }
            completion(nil,dbRef.key)
        }
    }
    
    static func updateUser(key: String, title: String ,completion: @escaping (Error?)->()){
        //Tasks that are being worked on
        print("key: \(key)")
        let indyRef = mainRef.child("users").child(TaskUser.current.uid).child("current").child(key)
        
        indyRef.setValue(title) { (error, dbRef) in
            if let err = error {
                completion(err)
                return
            }
            completion(nil)
        }    }
    
    func fun(){
        print("yes")
    }
    
    static func retrieveTasks(completion: @escaping (Task?,Int)->()){
        let ref = companyRef.child("currentTasks")
        ref.observe(DataEventType.childAdded) { (data) in
                print("Adding ")
                if let task = Task(snapshot: data){
                    task.shape.disableInteraction()
                    task.addTapGesture()
                    Constants.Data.liveTasks[task.key] = task
                    completion(task,0)
                }else{
                    completion(nil,0)
            }
        }
        ref.observe(DataEventType.childRemoved) { (data) in
            print("Child removed")
            if let task = Task(snapshot: data){
                completion(task,1)
            }else{
                completion(nil,0)
            }
            
        }
        ref.observe(DataEventType.childChanged) { (data) in
            print("Child changed")
            completion(nil,2)
        }
    }
    
    static func deleteTask(key: String,sender: UIViewController,completion: @escaping (Bool)->()){
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you have completed the whole task?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            completion(false)
        })
        
        let confirmAction =  UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let ref = companyRef.child("currentTasks").child(key)
            ref.removeValue { (error, ref) in
                if let err = error {
                    Alerts.simpleAlert(err: err, controller: sender)
                    completion(false)
                }
                completion(true)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        sender.present(alertController, animated: true)
    }

}
