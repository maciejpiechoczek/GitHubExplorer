//
//  ReleaseTableViewCell.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 25/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit

class ReleaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var webLinkButton: UIButton!
}
