//
//  File.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/27/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import Foundation
import UIKit

class RankPost {
    var username: String
    var id: String
    var score: Int
    var profileImage: String
    
    init(username: String, id: String, score: Int, profileImage: String) {
        self.username = username
        self.id = id
        self.score = score
        self.profileImage = profileImage
    }
}
