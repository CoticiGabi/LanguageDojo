//
//  EditPost.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/21/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import Foundation

class EditPost {
        var id: String
        var message: String
        var author: User
        var nrOfUpvotes: Int
        var nrOfDownvotes: Int
        var post: Post
        var usersWhoUpvoted: [String] = [String]()
        var usersWhoDownvoted: [String] = [String]()
        
        init(id: String, message: String, author: User, nrOfUpvotes: Int, nrOfDownvotes: Int, post: Post) {
            self.id = id
            self.message = message
            self.author = author
            self.nrOfUpvotes = nrOfUpvotes
            self.nrOfDownvotes = nrOfDownvotes
            self.post = post
        }
}
