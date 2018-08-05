//
//  UserService.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth.FIRUser
import FirebaseMessaging

struct UserService {
    
//    let key = ref.child("posts").childByAutoId().key
//    let post = ["uid": userID,
//                "author": username,
//                "title": title,
//                "body": body]
//    let childUpdates = ["/posts/\(key)": post,
//                        "/user-posts/\(userID)/\(key)/": post]
//    ref.updateChildValues(childUpdates)
    //Create the user in the database
    
    
//    self.uid = dict["uid"] as? String
//    self.username = dict["username"] as? String
//    self.companyID = dict["companyId"] as? String
    
    static func switchCurrentCompany(newId: String, email: String, password: String,sender: UIViewController, completion: @escaping (Bool)->()){
        let ref = Database.database().reference()
        //assume logged in
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error: error logging in")
                Alerts.simpleAlert(err: error, controller: sender)
                return completion(false)
            }
            let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let currUser = TaskUser(snapshot: snapshot) else {
                    return completion(false)
                }
                TaskUser.setCurrent(currUser)
                let userUpdate = "/users/\(TaskUser.current.uid)/companyId"
                ref.updateChildValues([userUpdate: newId]){ (error, ref) in
                    if let error = error {
                        return completion(false)
                    }
                        //Check if company id is valid
                        let checkLegitimateCompany = Database.database().reference().child("company").child(newId)
                    
                        checkLegitimateCompany.observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChildren(){
                                return completion(true)
                            }
                           return completion(false)
                        })
                }
            })
        }
    }
    
    static func create(user: User, username: String, companyID: String,completion: @escaping (Error?, TaskUser?, String?)->()){
        let ref = Database.database().reference()
        var userAttribute = ["username" : username,
                             "companyId" : companyID]
        let userToken = Messaging.messaging().fcmToken
        let userUpdate = "/users/\(user.uid)"
        let tokenUpdate = "/company/\(companyID)/tokens/\(user.uid)"
        let baseImage = Database.database().reference().child("company").child(companyID).child("imageURL")
        
        ref.updateChildValues([userUpdate: userAttribute,
                               tokenUpdate: userToken
        ]) { (error, databaseReference) in
            if let error = error {
                completion(error,nil,nil)
                return
            }
            baseImage.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let imageURL = snapshot.value as? String else{
                    return completion(nil,nil,nil)
                }
                userAttribute["uid"] = user.uid
                completion(nil, TaskUser(userAttribute),imageURL)
            })
        }
    }
    
    static func checkCompanyIds(companyID: String, completion: @escaping (Bool)->()){
        let ref = Database.database().reference().child("company")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(companyID){
                //Exists
                completion(true)
            }else{
                //Doesnt exists
                completion(false)
            }
        }
    }
}
