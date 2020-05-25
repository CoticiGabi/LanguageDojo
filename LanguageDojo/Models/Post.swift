//
//  Post.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/15/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import Foundation

class Post {
    var id: String
    var message: String
    var author: User
//    var timestamp: Double
    var nrOfLikes: Int
    var language: String
    
    init(id: String, message: String, author: User, nrOfLikes: Int, language: String) {
        self.id = id
        self.message = message
        self.author = author
//        self.timestamp = timestamp
        self.nrOfLikes = nrOfLikes
        self.language = language
    }
}
