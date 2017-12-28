//
//  ReleasesViewModel.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 25/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

class ReleasesViewModel {
    
    // MARK: Private Properties
    private let requestProvider: GitHubRequestProviding
    private var releases = [Release]() {
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
        
        return releases.count
    }
    
    func releaseNameForIndexPath(_ indexPath: IndexPath) -> String {
        
        return releases[indexPath.row].name
    }
    
    func releaseTagForIndexPath(_ indexPath: IndexPath) -> String {
        
        return releases[indexPath.row].tagName
    }
    
    func authorAndDateForIndexPath(_ indexPath: IndexPath) -> String {
        
        let authorName = releases[indexPath.row].author.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let creationDate = releases[indexPath.row].publishedDate
        let creationDateString = dateFormatter.string(from: creationDate)
        
        return "\(authorName) released this on \(creationDateString)"
        
        return releases[indexPath.row].author.name // TODO: Add date of release to this string
    }
    
    func authorAvatarURLForIndexPath(_ indexPath: IndexPath) -> URL? {
        
        return releases[indexPath.row].author.avatarURL
    }
    
    func gitHubURLForIndexPath(_ indexPath: IndexPath) -> URL {
        
        return releases[indexPath.row].gitHubURL
    }
    
    func reloadData() {
        
        guard let repositoryName = repositoryName else {
            fatalError("Can not unwrap repositoryName")
        }
        
        isLoading = true
        requestProvider.getReleases(forOrganization: "comapi", repositoryName: repositoryName) { [weak self] (releases, error) in
            
            self?.isLoading = false
            if let error = error {
                
                print(error)
                self?.errorMessage = R.string.localized.generalErrorGeneric()
                
            } else if let releases = releases {
                
                self?.releases = releases
            }
        }
    }
}
