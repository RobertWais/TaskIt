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

class TaskUser: Codable {
    
    private static var _currUser: TaskUser?
    
    let uid: String
    let username: String
    let companyID: String
    
    
    static var current: TaskUser {
        guard let currentUser = _currUser else {
            //Re route user to login screen **
            fatalError("No currecurrentUser")
        }
        return currentUser
    }
    
    static func setNil(){
            UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    static func setCurrent(_ user: TaskUser){
        if let data = try? JSONEncoder().encode(user){
            UserDefaults.standard.set(data,forKey: "currentUser")
        }
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
    
    init?(_ dict: [String: Any?]){
        guard let username = dict["username"] as? String,
            let uid = dict["uid"] as? String,
            let companyId = dict["companyId"] as? String else {return nil}
        
        self.uid = uid
        self.username = username
        self.companyID = companyId
    }
    
}
