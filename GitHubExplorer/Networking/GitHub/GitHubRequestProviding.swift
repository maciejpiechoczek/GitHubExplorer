//
//  GitHubRequestProviding.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 28/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

protocol GitHubRequestProviding {
    
    func getRepositories(forOrganization organizationName: String, completionHandler: @escaping (_ repositories: [Repository]?, _ error: APIError?) -> ())
    
    func getCommits(forOrganization organizationName: String, repositoryName: String, completionHandler: @escaping (_ commits: [Commit]?, _ error: APIError?) -> ())
    
    func getReleases(forOrganization organizationName: String, repositoryName: String, completionHandler: @escaping (_ releases: [Release]?, _ error: APIError?) -> ())
}
