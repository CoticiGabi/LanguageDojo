//
//  EditViewCell.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/21/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditViewCell: UITableViewCell {
    
    @IBOutlet weak var editPostUsernameLabel: UILabel!
    @IBOutlet weak var editPostProfileImage: UIImageView!
    @IBOutlet weak var editPostMessage: UILabel!
    @IBOutlet weak var editPostUpvotes: UIButton!
    @IBOutlet weak var editPostDownvotes: UIButton!
    @IBOutlet weak var editPostNrOfUpvotes: UILabel!
    @IBOutlet weak var editPostNrOfDownvotes: UILabel!
    
    var editId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        let homeVc = HomeViewController(nibName: "Home", bundle: nil)
        homeVc.editMessage = editPostMessage.text!
        homeVc.upvotes = Int(editPostNrOfUpvotes.text!)!
        homeVc.downvotes = Int(editPostNrOfDownvotes.text!)!
    }

    func setEditPost(editPost:EditPost) {
        editPostUsernameLabel.text = editPost.author.username
        editPostMessage.text = editPost.message
        editPostNrOfUpvotes.text = String(editPost.nrOfUpvotes)
        editPostNrOfDownvotes.text = String(editPost.nrOfDownvotes)
            
       }
    
    @IBAction func upvoteBtn_touchUpInside(_ sender: Any) {
        let ref = Database.database().reference().child("edits").child(editId)
        editPostUpvotes.isSelected = !editPostUpvotes.isSelected
        if editPostUpvotes.isSelected {
            editPostDownvotes.isSelected = false
            editPostDownvotes.setTitleColor(.black, for: UIControl.State.normal)
            editPostUpvotes.setTitleColor(.red, for: UIControl.State.normal)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let editPost = snapshot.value as? [String: Any] {
                    print(editPost)
                    let upvotes = editPost["upvotes"] as? Double
                    ref.updateChildValues(["upvotes": upvotes! + 1])
                }
            })
        }
        print(editPostUpvotes.isSelected)
    }
    

    @IBAction func downvoteBtn_touchUpInside(_ sender: Any) {
        let ref = Database.database().reference().child("edits").child(editId)
        editPostDownvotes.isSelected = !editPostDownvotes.isSelected
        if editPostDownvotes.isSelected {
            editPostUpvotes.isSelected = false
            editPostUpvotes.setTitleColor(.black, for: UIControl.State.normal)
            editPostDownvotes.setTitleColor(.red, for: UIControl.State.normal)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let editPost = snapshot.value as? [String: Any] {
                    print(editPost)
                    let downvotes = editPost["downvotes"] as? Double
                    ref.updateChildValues(["downvotes": downvotes! + 1])
                }
            })
        }
        print(editPostUpvotes.isSelected)
    }
    
}
