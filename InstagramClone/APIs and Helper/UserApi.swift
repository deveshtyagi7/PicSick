//
//  UserApi.swift
//  PicSick
//
//  Created by Devesh Tyagi on 19/05/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
class UserApi{
    var REF_USERS = Database.database().reference().child("Users")
    
    func observeUsers(withId uid : String , completion : @escaping (Users) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let user = Users.transformUser(dict: dict ,key: snapshot.key)
                completion(user)
            }
            
        })
    }
    
    func observeCurrentUser(completion : @escaping (Users) -> Void){
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let user = Users.transformUser(dict: dict ,key: snapshot.key)
                
                completion(user)
            }
            
        })
    }
    
    func observeUsers(completion : @escaping (Users) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = Users.transformUser(dict: dict ,key: snapshot.key)
                if user.id! != Api.User.CURRENT_USER?.uid {
                    completion(user)
                    
                }
            }
        }
    }
    
    func queryUsers(withText text: String, completion : @escaping (Users) -> Void){
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach { (s) in
                let child  = s as! DataSnapshot
                if let dict = child.value as? [String : Any]{
                    let user = Users.transformUser(dict: dict ,key: child.key)
                    completion(user)
                }
            }
        }
    } 
    
    
    var CURRENT_USER : User?{
        if let currentUser = Auth.auth().currentUser{
            return currentUser
        }
        return nil
    }
    var REF_CURRENT_USER : DatabaseReference?{
        guard let currentUser = Auth.auth().currentUser else{
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
    
}
