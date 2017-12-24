//
//  User.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let name: String
    let avatarURL: URL?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "login"
        case avatarURL = "avatar_url"
    }
}
