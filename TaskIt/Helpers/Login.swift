//
//  Login.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import Foundation
import FirebaseAuth
import FirebaseAuth.FIRUser


struct Login {
    
    static func signUp(email: String, password: String, username: String, controller: UIViewController,completion: @escaping
        (Bool)->()){
        AuthService.createUser(email: email, password: password) { (error, user) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: controller)
                completion(false)
                return
            }
            UserService.create(user: user!, username: username, companyID: "1234", completion: { (error, user) in
                if let error = error {
                    Alerts.simpleAlert(err: error, controller: controller)
                    completion(false)
                    return
                }
                taskUser.setCurrent(user!)
                completion(true)
            })
        }
    }
    
    
}