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
    var usersWhoUpvoted: [String] = [String]()
    var usersWhoDownvoted: [String] = [String]()


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
        self.editPostUpvotes.isEnabled = false
        self.editPostDownvotes.isEnabled = true
        self.editPostDownvotes.setTitleColor(.black, for: UIControl.State.normal)
        let ref = Database.database().reference()
        ref.child("edits").child(self.editId).observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot)
            if let edit = snapshot.value as? [String: Any] {
                let keyToPost = ref.child("edits").childByAutoId().key
                let updateUpvotes: [String: Any] = ["usersWhoUpvoted/\(keyToPost)" : UserService.currentUser?.uid]
//                print(updateUpvotes)
                ref.child("edits").child(self.editId).updateChildValues(updateUpvotes, withCompletionBlock: {(error, ref) in
//                    print("A")
                    if error == nil {
                        Database.database().reference().child("edits").child(self.editId).observeSingleEvent(of: .value, with: {snap in
//                            print(snap)
                            if let properties = snap.value as? [String: Any] {
                                if let upvotes = properties["usersWhoUpvoted"] as? [String:Any]
                                    {
//                                    print("a intrat aici")
                                    let count = upvotes.count
//                                    print(count)
                                    self.editPostNrOfUpvotes.text = "\(count)"
                                    let update = ["upvotes": count]
                                    Database.database().reference().child("edits").child(self.editId).updateChildValues(update)
                                        
                                    if let downvotes = properties["usersWhoDownvoted"] as? [String: Any] {
//                                        print("AAAA")
                                        for (id, user) in downvotes {
                                            if user as? String == UserService.currentUser?.uid {
                                                Database.database().reference().child("edits").child(self.editId).child("usersWhoDownvoted").child(id).removeValue(completionBlock: {(error, reff) in
//                                                    print("l-a gasit aici")
                                                    if error == nil {
                                                        Database.database().reference().child("edits").child(self.editId).observeSingleEvent(of: .value, with: {snap in
    //                                                        print("bine 1")
                                                            if let prop = snap.value as? [String: Any] {
    //                                                            print("bine 2")
                                                                if let down = prop["usersWhoDownvoted"] as? [String: Any] {
                                                                    let countDown = down.count
                                                                    self.editPostNrOfDownvotes.text = "\(countDown)"
                                                                    Database.database().reference().child("edits").child(self.editId).updateChildValues(["downvotes": countDown])
                                                                } else {
    //                                                                print("prost")
                                                                    self.editPostNrOfDownvotes.text = "0"
                                                                    Database.database().reference().child("edits").child(self.editId).updateChildValues(["downvotes": 0])
                                                                }
                                                            }
                                                        })
                                                    } else {
                                                        print("Error")
                                                    }
                                                })
                                            }
                                        }
                                        }
                                    
                                    self.editPostUpvotes.setTitleColor(.red, for: .normal)
                                } else {
                                    print("error")
                                }
                            }
                        })
                    } else {
                        print("error")
                        print(error.debugDescription)
                    }
                })
            }
        })
//        editPostUpvotes.isSelected = !editPostUpvotes.isSelected
//        if editPostUpvotes.isSelected {
//            editPostDownvotes.isSelected = false
//            editPostDownvotes.setTitleColor(.black, for: UIControl.State.normal)
//            editPostUpvotes.setTitleColor(.red, for: UIControl.State.normal)
//            ref.observeSingleEvent(of: .value, with: { snapshot in
//                if let editPost = snapshot.value as? [String: Any] {
//                    print(editPost)
//                    let upvotes = editPost["upvotes"] as? Double
//                    ref.updateChildValues(["upvotes": upvotes! + 1])
//
//                }
//            })
//        }
//        print(editPostUpvotes.isSelected)
    }
    

    @IBAction func downvoteBtn_touchUpInside(_ sender: Any) {
        
        
        self.editPostDownvotes.isEnabled = false
        self.editPostUpvotes.isEnabled = true
        let ref = Database.database().reference()
        ref.child("edits").child(self.editId).observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot)
            if let edit = snapshot.value as? [String: Any] {
                let keyToPost = ref.child("edits").childByAutoId().key
                let updateDownvotes: [String: Any] = ["usersWhoDownvoted/\(keyToPost)" : UserService.currentUser?.uid]
//                print(updateUpvotes)
                ref.child("edits").child(self.editId).updateChildValues(updateDownvotes, withCompletionBlock: {(error, ref) in
//                    print("A")
                    if error == nil {
                        Database.database().reference().child("edits").child(self.editId).observeSingleEvent(of: .value, with: {snap in
//                            print(snap)
                            if let properties = snap.value as? [String: Any] {
                                if let downvotes = properties["usersWhoDownvoted"] as? [String:Any]
                                    {
//                                    print("a intrat aici")
                                    let count = downvotes.count
//                                    print(count)
                                    self.editPostNrOfDownvotes.text = "\(count)"
                                    let update = ["downvotes": count]
                                        
                                        
                                    Database.database().reference().child("edits").child(self.editId).updateChildValues(update)
                                    if let upvotes = properties["usersWhoUpvoted"] as? [String: Any] {
//                                        print("AAAA")
                                        for (id, user) in upvotes {
//                                            print(user)
                                            if user as? String == UserService.currentUser?.uid {
//                                                print("e bine aici")
                                            Database.database().reference().child("edits").child(self.editId).child("usersWhoUpvoted").child(id).removeValue(completionBlock: {(error, reff) in
//                                                    print(id)
                                                    if error == nil {
//                                                        print("corecttttttt")
                                                        Database.database().reference().child("edits").child(self.editId).observeSingleEvent(of: .value, with: {snap in
//                                                            print("bine 1")
                                                            if let prop = snap.value as? [String: Any] {
                                                                print(prop)
//                                                                print("bine 2")
                                                                if let up = prop["usersWhoUpvoted"] as? [String: Any] {
//                                                                    print(up)
//                                                                    print("e bine 3")
                                                                    let countUp = up.count
//                                                                    print(countUp)
                                                                    self.editPostNrOfUpvotes.text = "\(countUp)"
                                                                    Database.database().reference().child("edits").child(self.editId).updateChildValues(["upvotes": countUp])
                                                                } else {
    //                                                                print("prost")
                                                                    self.editPostNrOfUpvotes.text = "0"
                                                                    Database.database().reference().child("edits").child(self.editId).updateChildValues(["upvotes": 0])
                                                                }
                                                            }
                                                        })
                                                    } else {
                                                        print("Error")
                                                    }
                                                })
                                            }
                                        }
                                        }
                                    
                                    self.editPostDownvotes.setTitleColor(.red, for: .normal)
                                    self.editPostUpvotes.setTitleColor(.black, for: UIControl.State.normal)
                                } else {
                                    print("error")
                                }
                            }
                        })
                    } else {
                        print("error")
                        print(error.debugDescription)
                    }
                })
            }
        })
        
        
        
//        let ref = Database.database().reference().child("edits").child(editId)
//        editPostDownvotes.isSelected = !editPostDownvotes.isSelected
//        if editPostDownvotes.isSelected {
//            editPostUpvotes.isSelected = false
//            editPostUpvotes.setTitleColor(.black, for: UIControl.State.normal)
//            editPostDownvotes.setTitleColor(.red, for: UIControl.State.normal)
//            ref.observeSingleEvent(of: .value, with: { snapshot in
//                if let editPost = snapshot.value as? [String: Any] {
//                    print(editPost)
//                    let downvotes = editPost["downvotes"] as? Double
//                    ref.updateChildValues(["downvotes": downvotes! + 1])
//                }
//            })
//        }
//        print(editPostUpvotes.isSelected)
    }
    
    
    @IBAction func goBackBtn_touchUpInside(_ sender: Any) {
    }
    
}
