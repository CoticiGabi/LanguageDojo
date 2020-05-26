//
//  User.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/18/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User {
    var uid: String
    var username: String
    var email: String
    var profileImage: String
    var masterLanguage: String
    var apprenticeLanguage: String
    var score: Int = 0
    
    init(uid: String, username: String, email: String, profileImage: String, masterLanguage: String, apprenticeLanguage: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImage = profileImage
        self.masterLanguage = masterLanguage
        self.apprenticeLanguage = apprenticeLanguage
    }
    
}

