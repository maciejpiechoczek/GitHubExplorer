//
//  Commit.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

struct Commit: Decodable {
    
    let sha: String
    let message: String
    let committer: User
    let date: Date
    let gitHubURL: URL
    
    enum CodingKeys: String, CodingKey {
        
        case sha
        case commit
        case committer
        case gitHubURL = "html_url"
    }
    
    enum CommitCodingKeys: String, CodingKey {
        
        case message
        case committer
    }
    
    enum CommitterCodingKeys: String, CodingKey {
        
        case name
        case date
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commitContainer = try container.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        let committerContainer = try commitContainer.nestedContainer(keyedBy: CommitterCodingKeys.self, forKey: .committer)
        
        sha = try container.decode(String.self, forKey: .sha)
        message = try commitContainer.decode(String.self, forKey: .message)
        
        do {
            committer = try container.decode(User.self, forKey: .committer)
        } catch {
            let name = try committerContainer.decode(String.self, forKey: .name)
            committer = User(name: name, avatarURL: nil)
        }
        
        let dateString = try committerContainer.decode(String.self, forKey: .date)
        guard let dateFromISO8601 = ISO8601DateFormatter().date(from: dateString) else {

            throw APIError.objectSerialization(reason: APIError.Description.wrongDateFormat.rawValue)
        }
        date = dateFromISO8601
        
        gitHubURL = try container.decode(URL.self, forKey: .gitHubURL)
    }
}
