//
//  AuthService.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import Foundation
import FirebaseAuth
import FirebaseAuth.FIRUser

struct AuthService{
    
    static func createUser(email: String,password: String, completion: @escaping (Error?,User?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
        
            //If there is an error return it to caller
            if let err = error {
                completion(err,nil)
                return
            }
            //Set Current User to the user that is now signed in
            completion(nil,authResult?.user)
        }
    }
}
