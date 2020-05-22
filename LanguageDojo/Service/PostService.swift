//
//  PostService.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/21/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import Foundation
import Firebase

class PostService {
    
    static var currentPost: Post?
    
    static func observePost(_ uid:String, completion: @escaping((_ user: User?) -> ())) {
        let userRef = Database.database().reference().child("posts/\(uid)")
        
        userRef.observe(.value, with: {snapshot in
            var user: User?
            
            if let dict = snapshot.value as? [String: Any],
                let username = dict["username"] as? String,
                let email = dict["email"] as? String,
                let masterLanguage = dict["masterLanguage"] as? String,
                let apprenticeLanguage = dict["apprenticeLanguage"] as? String,
                let profileImage = dict["profileImage"] as? String,
                let url = URL(string: profileImage){
                    user = User(uid: uid, username: username, email: email, profileImage: profileImage, masterLanguage: masterLanguage, apprenticeLanguage: apprenticeLanguage)
            }
            completion(user)
        })
    }
    
}
