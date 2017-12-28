//
//  RepositoriesViewModel.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 24/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

class RepositoriesViewModel {

    // MARK: Private Properties
    private let requestProvider: GitHubRequestProviding
    private var repositories = [Repository]() {
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
        
        return repositories.count
    }
    
    func repositoryNameForIndexPath(_ indexPath: IndexPath) -> String {
        
        return repositories[indexPath.row].name
    }
    
    func descriptionForIndexPath(_ indexPath: IndexPath) -> String {
        
        return repositories[indexPath.row].description ?? ""
    }
    
    func languageForIndexPath(_ indexPath: IndexPath) -> String {
        
        if let language = repositories[indexPath.row].language {
            
            return "Language: \(language)"
        } else {
            
            return ""
        }
    }
    
    func gitHubURLForIndexPath(_ indexPath: IndexPath) -> URL {
        
        return repositories[indexPath.row].gitHubURL
    }
    
    func reloadData() {
        
        isLoading = true
        requestProvider.getRepositories(forOrganization: "comapi") { [weak self] (repositories, error) in
            
            self?.isLoading = false
            if let error = error {
                
                print(error)
                self?.errorMessage = R.string.localized.generalErrorGeneric()
                
            } else if let repositories = repositories {
                
                self?.repositories = repositories
            }
        }
    }
}
