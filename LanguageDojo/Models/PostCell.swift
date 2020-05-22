//
//  PostCell.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/18/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    
    
    var post: Post! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
    }
}
