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
    static func create(user: User, username: String, companyID: String,completion: @escaping (Error?,User?)->()){
        
        let userAttribute = ["username" : username,
                             "companyId" : companyID]
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.setValue(userAttribute) { (error, ref) in
            if let error = error {
                completion(error,nil)
                return
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = taskUser(snapshot: snapshot)
            })
        }
        
    }
}
