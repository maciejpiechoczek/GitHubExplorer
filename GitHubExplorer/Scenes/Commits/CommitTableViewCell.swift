//
//  CommitTableViewCell.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 25/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit

class CommitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var shaLabel: UILabel!
    @IBOutlet weak var committerLabel: UILabel!
    @IBOutlet weak var committerAvatar: UIImageView!
    @IBOutlet weak var webLinkButton: UIButton!
}
