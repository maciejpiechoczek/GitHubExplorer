//
//  GitHubRequestProvider.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 17/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

class GitHubRequestProvider {
    
    private let provider = RequestProvider<GitHubAPI>()
    
    func getOrganization(_ organizationName: String, completionHandler: @escaping (_ organization: Organization?, _ error: APIError?) -> ()) {
        
        provider.performRequest(.organization(orgName: organizationName), completionHandler: completionHandler)
    }
    
    func getRepositories(forOrganization organizationName: String, completionHandler: @escaping (_ repositories: [Repository]?, _ error: APIError?) -> ()) {
        
        provider.performRequest(.repositories(forOrganization: organizationName), completionHandler: completionHandler)
    }
    
    func getCommits(forOrganization organizationName: String, repositoryName: String, completionHandler: @escaping (_ commits: [Commit]?, _ error: APIError?) -> ()) {
        
        provider.performRequest(.commits(forOrganization: organizationName, repositoryName: repositoryName), completionHandler: completionHandler)
    }
    
    func getReleases(forOrganization organizationName: String, repositoryName: String, completionHandler: @escaping (_ releases: [Release]?, _ error: APIError?) -> ()) {
        
        provider.performRequest(.releases(forOrganization: organizationName, repositoryName: repositoryName), completionHandler: completionHandler)
    }
}
