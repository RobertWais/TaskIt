//
//  TaskUser.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import Foundation



//
//  User.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class taskUser: Codable {
    
    private static var _currUser: taskUser?
    
    let uid: String
    let username: String
    let companyID: String
    
    
    static var current: taskUser {
        guard let currentUser = _currUser else {
            //Re route user to login screen **
            fatalError("No currecurrentUser")
        }
        return currentUser
    }
    
    static func setCurrent(_ user: taskUser){
        _currUser = user
    }
    
    //Initializers
    init(uid: String, username: String, companyId: String){
        self.uid = uid
        self.username = username
        self.companyID = companyId
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: Any],
            let username = dict["username"] as? String,
            let compID = dict["companyId"] as? String
            else {return nil}
        self.uid = snapshot.key
        self.username = username
        self.companyID = compID
    }
    
}
