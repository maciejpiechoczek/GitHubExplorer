//
//  Repository.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let name: String
    let description: String?
    let language: String?
    let gitHubURL: URL
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case description
        case language
        case gitHubURL = "html_url"
    }
}
