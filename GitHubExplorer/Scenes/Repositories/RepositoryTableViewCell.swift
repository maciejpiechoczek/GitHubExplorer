//
//  RepositoryTableViewCell.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 25/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var webLinkButton: UIButton!
    @IBOutlet weak var commitsButton: UIButton!
    @IBOutlet weak var releasesButton: UIButton!
}
