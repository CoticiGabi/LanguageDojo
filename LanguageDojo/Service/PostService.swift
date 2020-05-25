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
    
    static func observePost(_ uid:String, completion: @escaping((_ post: Post?) -> ())) {
        let postRef = Database.database().reference().child("posts/\(uid)")
        
        postRef.observe(.value, with: {snapshot in
            var post: Post?
            
            if let dict = snapshot.value as? [String: Any],
                let message = dict["message"] as? String,
                let author = dict["author"] as? User,
                let nrOfLikes = dict["likes"] as? Int,
                let language = dict["language"] as? String{
                    post = Post(id: uid, message: message, author: author, nrOfLikes: nrOfLikes, language: language)
            }
            completion(post)
        })
    }
    
}
