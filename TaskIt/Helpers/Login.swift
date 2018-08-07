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
    
    static func signUp(email: String, password: String, username: String, companyId: String, controller: UIViewController,completion: @escaping
        (String?)->()){
        AuthService.createUser(email: email, password: password) { (error, user) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: controller)
                return completion(nil)
            }
            guard let user = user else{
                return completion(nil)
            }
            UserService.create(user: user, username: username, companyID: companyId, completion: { (error, user, url) in
                if let error = error {
                    Alerts.simpleAlert(err: error, controller: controller)
                   return  completion(nil)
                }
                guard let user = user else{
                    return completion(nil)
                }
                TaskUser.setCurrent(user)
                completion(url)
            })
        }
    }
    
    static func signOut(){
        do{
           try Auth.auth().signOut()
        }catch let error{
        }
    }
    
    
}
