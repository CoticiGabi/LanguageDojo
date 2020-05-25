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
    func editText(textToEdit: String!, post:Post!)
//    func setCurrentPost(currentPost: Post)
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
    var author: User!
    var nrOfLikes: Int!
    var language: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
//        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
//        profileImageView.clipsToBounds = true
        
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
        self.delegate.editText(textToEdit: textToEdit, post: Post(id: postId, message: textToEdit, author: author, nrOfLikes: nrOfLikes, language: language))
//        let storyboard: UIStoryboard = UIStoryboard(name: "Start", bundle: nil)
//        let homeVc: HomeViewController = storyboard.instantiateViewController(identifier: "Home") as! HomeViewController
//        homeVc.post = Post(id: postId, message: textToEdit, author: author, nrOfLikes: nrOfLikes)
//        homeVc.currentPostId = postId
//        let editVc = EditTableViewController(nibName: "editViewController", bundle: nil)
//        editVc.originalPost = Post(id: postId, message: textToEdit, author: author, nrOfLikes: nrOfLikes)
//        print(homeVc.post)
//        print(postId)
//        print(textToEdit)
//        print(author)
//        print(nrOfLikes)
    }
    
    
    @IBAction func commentOnPost(_ sender: Any) {
    }
    
//    func setCurrPost() {
//        self.delegate.setCurrentPost(currentPost: Post(id: postId, message: textToEdit, author: author, nrOfLikes: nrOfLikes))
//    }
}
