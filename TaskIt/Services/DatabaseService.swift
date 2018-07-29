//
//  DatabaseService.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import Foundation
import FirebaseDatabase


struct DatabaseService {
    
    private static let mainRef = Database.database().reference()
    static let companyRef = mainRef.child("company").child(TaskUser.current.companyID)

    static func createCompany(uniqueId: String, name: String, sender: UIViewController,completion: @escaping (Bool)->()){
        let ref = Database.database().reference().child("company").childByAutoId()
        let companyInfo = ["name" : name]
        ref.setValue(companyInfo) { (error, ref) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: sender)
                completion(false)
            }else{
                Alerts.displayKey(uniqueID: "\(ref.key)", sender: sender, finished: {
                    completion(true)
                    print("Closed")
                })
            }
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
                print("Error: \(error)")
                if let err=error {
                    Alerts.simpleAlert(err: err, controller: sender)
                    completion(false)
                    return
                }
                completion(true)
            })
        }
        //Two Functions
        //1) Update User Posts
        //2) Update company array of tasks
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
        }

        
    }
    
    
    static func retrieveTasks(completion: @escaping ([Task])->()){
        let ref = companyRef.child("currentTasks")
        var returnTasks = [Task]()
        
        ref.observe(DataEventType.value) { (data) in
            for child in data.children {
                if let task = Task(snapshot: child as! DataSnapshot){
                    task.shape.disableInteraction()
                    returnTasks.append(task)
                }
            }
            completion(returnTasks)
        }
    }
    
}



//    Database.database().reference().child("company").child(TaskUser.current.companyID)
//    // Generate a reference to a new location and add some data using push()
//    var newPostRef = postsRef.push({
//        author: "gracehop",
//        title: "Announcing COBOL, a New Programming Language"
//    });
//    // Get the unique ID generated by push() by accessing its key
//    var postID = newPostRef.key;
//
