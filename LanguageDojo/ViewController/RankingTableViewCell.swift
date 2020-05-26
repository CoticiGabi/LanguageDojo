//
//  RankingTableViewCell.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/27/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setRankPost(rankPost: RankPost, rank: Int) {
        usernameLabel.text = rankPost.username
        scoreLabel.text = String(rankPost.score)
        rankLabel.text = String(rank)
    }
}
