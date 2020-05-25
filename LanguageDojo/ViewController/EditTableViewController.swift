//
//  EditTableViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/21/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditTableViewController: UITableViewController, editTextProtocol {
    
    func editText(textToEdit: String!, post: Post!) {
        text = textToEdit
        originalPost = post
        
    }
    
    var editPosts = [EditPost]()
    var originalPost: Post!
    var text: String = ""


    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("AAAAAAAAA")
        
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

        observeEdits()
    }
    
    func observeEdits() {
        
        print("A intrat")
        let editRef = Database.database().reference().child("edits")
        editRef.observe(.value, with: { snapshot in
            print(snapshot)
            var tempEdits = [EditPost]()
            for child in snapshot.children {
                print(child)
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let editPost = dict["post"] as? [String: Any],
                    let uid = editPost["uid"] as? String,
                    let language = editPost["language"] as? String,
                    let message = editPost["message"] as? String,
                    let nrOfLikes = editPost["likes"] as? Int,
                    let author = editPost["postAuthor"] as? [String: Any],
                    let authorUid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let email = author["email"] as? String,
                    let masterLanguage = author["masterLanguage"] as? String,
                    let apprenticeLanguage = author["apprenticeLanguage"] as? String,
                    let profileImage = author["profileImage"] as? String,
                    let editMessage = dict["editMessage"] as? String,
                    let upvotes = dict["upvotes"] as? Int,
                    let downVotes = dict["downvotes"] as? Int
                {
                     let user = User(uid: authorUid, username: username, email: email, profileImage: profileImage, masterLanguage: masterLanguage, apprenticeLanguage: apprenticeLanguage)
                        let post = Post(id: uid, message: message, author: user, nrOfLikes: nrOfLikes, language: language)
                        let currentUser = UserService.currentUser
                        let editPost = EditPost(id: childSnapshot.key, message: editMessage, author: currentUser!, nrOfUpvotes:    upvotes, nrOfDownvotes: downVotes, post: post)
                    tempEdits.append(editPost)
                    print("Corect")
                } else {
                    print("Error")
                }
            }
            self.editPosts = tempEdits
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return editPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath) as! PostTableViewCell
//            cell.set(post: originalPost)
//            return cell
//
//        }
//        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! EditViewCell
            cell.setEditPost(editPost: editPosts[indexPath.row])
            cell.editId = self.editPosts[indexPath.row].id
            return cell
//        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
