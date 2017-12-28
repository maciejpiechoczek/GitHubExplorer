//
//  GitHubAPI.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Moya

enum GitHubAPI {
    
    case repositories(forOrganization: String)
    case commits(forOrganization: String, repositoryName: String)
    case releases(forOrganization: String, repositoryName: String)
}

extension GitHubAPI: API {
    
    var baseURL: URL {
        let gitHubAPIBaseURL = "https://api.github.com"
        
        guard let url = URL(string: gitHubAPIBaseURL) else {
            fatalError("Not an URL: \(gitHubAPIBaseURL)")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .repositories(let organizationName):
            return "/orgs/\(organizationName)/repos"
            
        case .commits(let organizationName, let repositoryName):
            return "/repos/\(organizationName)/\(repositoryName)/commits"
            
        case .releases(let organizationName, let repositoryName):
            return "/repos/\(organizationName)/\(repositoryName)/releases"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        let params: [String: Any] = ["per_page": 100]
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
}
