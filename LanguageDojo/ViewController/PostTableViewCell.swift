//
//  PostTableViewCell.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/19/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol editTextProtocol {
    func editText(textToEdit: String!)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nrOfLikesLabel: UILabel!
    
    
    var postId: String!
    var textToEdit: String!
    var delegate: editTextProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post:Post) {
            usernameLabel.text = post.author.username
            postTextLabel.text = post.message
            nrOfLikesLabel.text = String(post.nrOfLikes)
            
       }
    
    
    @IBAction func likePost(_ sender: Any) {
    
        let ref = Database.database().reference().child("posts").child(postId)
        likeButton.isSelected = !likeButton.isSelected
        if likeButton.isSelected {
            likeButton.setImage(UIImage(named: "notification_icon_selected"), for: UIControl.State.normal)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let post = snapshot.value as? [String: Any] {
                    print(post)
                    let likes = post["likes"] as? Double
                    ref.updateChildValues(["likes": likes! + 1])
                }
            })
        } else {
            likeButton.setImage(UIImage(named: "notification_icon"), for: UIControl.State.normal)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let post = snapshot.value as? [String: Any] {
                    print(post)
                    let likes = post["likes"] as? Double
                    ref.updateChildValues(["likes": likes! - 1])
                }
            })
        }
        print(likeButton.isSelected)
        
    }
    
    
    @IBAction func editPost(_ sender: Any) {
        self.delegate.editText(textToEdit: textToEdit)
    }
    
    
    @IBAction func commentOnPost(_ sender: Any) {
    }
}
