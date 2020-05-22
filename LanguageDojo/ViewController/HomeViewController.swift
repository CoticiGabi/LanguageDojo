//
//  HomeViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/2/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UITableViewController, editTextProtocol {
    
    func editText(textToEdit: String!) {
       animateIn(desiredView: blurView)
        animateIn(desiredView: popUpView)
        editPostTextView.text = textToEdit
        
    }
    
    @IBOutlet weak var editPostTextView: UITextView!

    @IBOutlet weak var editTextLabel: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popUpView: UIView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var layoutGuide: UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        observePosts()

        //Pop up view
        blurView.bounds = self.view.bounds
        
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.3)
        popUpView.layer.borderColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0).cgColor
        popUpView.layer.borderWidth = 1.0

        // Edit and Cancel Btn
        editBtn.layer.cornerRadius = 5
        editBtn.layer.borderWidth = 1
        editBtn.layer.borderColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0).cgColor
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0).cgColor

    }
    
    @IBAction func cancelEditBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.blurView.alpha = 0
            self.popUpView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.popUpView.alpha = 0
        }, completion:  { _ in
            self.blurView.removeFromSuperview()
            self.popUpView.removeFromSuperview()
            
        })
    }
    
    @IBAction func postEditBtn(_ sender: Any) {
    }
    
    //Animate poUp
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view
        backgroundView?.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = CGPoint(x: (backgroundView?.bounds.width)! / 2, y: (backgroundView?.bounds.height)! / 4)
 

        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1

        })
    }
    
    func observePosts() {
        let postRef = Database.database().reference().child("posts")
        postRef.observe(.value, with: { snapshot in

            var tempPost = [Post]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let author = dict["author"] as? [String: Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let email = author["email"] as? String,
                    let masterLanguage = author["masterLanguage"] as? String,
                    let apprenticeLanguage = author["apprenticeLanguage"] as? String,
                    let profileImage = author["profileImage"] as? String,
                    let url = URL(string: profileImage),
                    let message = dict["message"] as? String,
                    let language = dict["language"] as? String,
                    let nrOfLikes = dict["likes"] as? Int {
                    if uid != UserService.currentUser?.uid && language == UserService.currentUser?.masterLanguage{
                        let userProfile = User(uid: uid , username: username, email: email, profileImage: profileImage, masterLanguage: masterLanguage, apprenticeLanguage: apprenticeLanguage)
                        let post = Post(id: childSnapshot.key, message: message, author: userProfile, nrOfLikes: nrOfLikes)

                        tempPost.append(post)
                    }
                } else {
                    print("Error")
                }
            }
            self.posts = tempPost
            self.tableView.reloadData()
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        cell.postId = self.posts[indexPath.row].id
        cell.textToEdit = self.posts[indexPath.row].message
        cell.delegate = self
        return cell
    }

}
