//
//  UserService.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth.FIRUser

struct UserService {
    
    
    //Create the user in the database
    static func create(user: User, username: String, companyID: String,completion: @escaping (Error?,TaskUser?)->()){
        
        let userAttribute = ["username" : username,
                             "companyId" : companyID]
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.setValue(userAttribute) { (error, ref) in
            if let error = error {
                completion(error,nil)
                return
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = TaskUser(snapshot: snapshot)
                completion(nil,user)
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
