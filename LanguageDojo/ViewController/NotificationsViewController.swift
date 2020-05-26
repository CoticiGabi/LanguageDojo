//
//  NotificationsViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/2/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NotificationsViewController: UITableViewController {

    var ranks = [RankPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AAAA")

        // Do any additional setup after loading the view.
        
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

        observeRanks()
    }
    
    func observeRanks() {
        print("BBBB")
        let rankRef = Database.database().reference().child("users").queryOrdered(byChild: "score")
        rankRef.observe(.value, with: { snapshot in
            print("CCCC")
    //            print(snapshot)
            var tempRanks = [RankPost]()
            for child in snapshot.children {
                print("DDD")
                print(snapshot)
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let username = dict["username"] as? String,
                    let profileImage = dict["profileImage"] as? String,
                    let score = dict["score"] as? Int                {
                    print("EEE")
                    print(childSnapshot.key)
                    let rank = RankPost(username: username, id: childSnapshot.key, score: score, profileImage: profileImage)
                     tempRanks.insert(rank, at: 0)
                } else {
                    print("ERROR")
                }
            }
            self.ranks = tempRanks
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

         override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ranks.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingTableViewCell
            cell.setRankPost(rankPost: self.ranks[indexPath.row], rank: indexPath.row + 1)
            return cell
        }

}
