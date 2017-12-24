//
//  Organization.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

struct Organization: Decodable {
    
    let name: String
    let description: String
    let avatarURL: URL
    let blogURL: URL
    let gitHubURL: URL
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case description
        case avatarURL = "avatar_url"
        case blogURL = "blog"
        case gitHubURL = "html_url"
    }
}
