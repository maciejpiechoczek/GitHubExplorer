//
//  CommitsViewModel.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 25/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

class CommitsViewModel {
    
    // MARK: Private Properties
    private let requestProvider: GitHubRequestProviding
    private var commits = [Commit]() {
        didSet {
            reloadTableView?()
        }
    }
    
    // MARK: Initializers
    init(requestProvider: GitHubRequestProviding = GitHubRequestProvider()) {
        
        self.requestProvider = requestProvider
    }
    
    // MARK: Action Closures
    var reloadTableView: (()->())?
    var updateLoadingStatus: (()->())?
    var showErrorMessage: (()->())?
    
    // MARK: Public Interface
    var repositoryName: String? {
        didSet {
            reloadData()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            showErrorMessage?()
        }
    }
    
    var numberOfRows: Int {
        
        return commits.count
    }
    
    func commitMessageForIndexPath(_ indexPath: IndexPath) -> String {
        
        return commits[indexPath.row].message // TODO: Truncate after new line sign
    }
    
    func commitShaForIndexPath(_ indexPath: IndexPath) -> String {
        
        return commits[indexPath.row].sha
    }
    
    func committerAndDateForIndexPath(_ indexPath: IndexPath) -> String {
        
        let committerName = commits[indexPath.row].committer.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let commitDate = commits[indexPath.row].date
        let commitDateString = dateFormatter.string(from: commitDate)
        
        return "\(committerName) committed on \(commitDateString)"
    }
    
    func committerAvatarURLForIndexPath(_ indexPath: IndexPath) -> URL? {
        
        return commits[indexPath.row].committer.avatarURL
    }
    
    func gitHubURLForIndexPath(_ indexPath: IndexPath) -> URL {
        
        return commits[indexPath.row].gitHubURL
    }
    
    func reloadData() {
        
        guard let repositoryName = repositoryName else {
            fatalError("Can not unwrap repositoryName")
        }
        
        isLoading = true
        requestProvider.getCommits(forOrganization: "comapi", repositoryName: repositoryName) { [weak self] (commits, error) in
            
            self?.isLoading = false
            if let error = error {
                
                print(error)
                self?.errorMessage = R.string.localized.generalErrorGeneric()
                
            } else if let commits = commits {
                
                self?.commits = commits
            }
        }
    }
}
