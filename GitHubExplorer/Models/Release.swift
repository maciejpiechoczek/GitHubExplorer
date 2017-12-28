//
//  Release.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

struct Release: Decodable {
    
    let name: String
    let tagName: String
    let author: User
    let publishedDate: Date
    let gitHubURL: URL
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case tagName = "tag_name"
        case author
        case publishedDate = "published_at"
        case gitHubURL = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        tagName = try container.decode(String.self, forKey: .tagName)
        author = try container.decode(User.self, forKey: .author)
        
        let dateString = try container.decode(String.self, forKey: .publishedDate)
        guard let dateFromISO8601 = ISO8601DateFormatter().date(from: dateString) else {
            
            throw APIError.objectSerialization(reason: APIError.Description.wrongDateFormat.rawValue)
        }
        publishedDate = dateFromISO8601
        
        gitHubURL = try container.decode(URL.self, forKey: .gitHubURL)
    }
}
