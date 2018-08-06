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
    
    static func switchCurrentCompany(newId: String, email: String, password: String,sender: UIViewController, completion: @escaping (Bool)->()){
        let ref = Database.database().reference()
        //assume logged in
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: sender)
                return completion(false)
            }
            guard let id = user?.user.uid else{
                return
            }
            let userUpdate = "/users/\(id)/companyId"
            ref.updateChildValues([userUpdate: newId]){ (error, ref) in
                if let error = error {
                    return completion(false)
                }
                let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let currUser = TaskUser(snapshot: snapshot) else {
                        return completion(false)
                    }
                    //Check if company id is valid
                    let checkLegitimateCompany = Database.database().reference().child("company").child(newId)
                    checkLegitimateCompany.observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChildren(){
                            TaskUser.setCurrent(currUser)
                            if Constants.Data.liveCompanyIds.contains(newId){
                            }else{
                                let tempId = CoreDataHelper.newCompanyId()
                                tempId.id = newId
                                CoreDataHelper.saveId()
                            }
                            return completion(true)
                        }
                        return completion(false)
                    })
                })
            }
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
