//
//  CommitsViewController.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 12/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit
import Kingfisher

class CommitsViewController: UIViewController, RepositoryDetails {
    
    // MARK: Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Private Properties
    private let viewModel = CommitsViewModel()
    
    // MARK: RepositoryDetails
    var repositoryName: String? {
        get {
            return viewModel.repositoryName
        }
        set(newName) {
            viewModel.repositoryName = newName
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    // MARK: Private Methods
    private func setupViews() {
        tableView.allowsSelection = false
    }
    
    private func setupViewModel() {
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                
                if let numberOfRows = self?.viewModel.numberOfRows,
                    numberOfRows > 0 {
                    
                    self?.tableView.reloadData()
                } else {
                    
                    self?.viewModel.errorMessage = R.string.localized.commitsNoCommits()
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.tableView.isHidden = true
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.tableView.isHidden = false
                }
            }
        }
        
        viewModel.showErrorMessage = { [weak self] in
            DispatchQueue.main.async {
                
                if let errorMessage = self?.viewModel.errorMessage {
                    self?.tableView.isHidden = true
                    self?.errorLabel.isHidden = false
                    
                    self?.errorLabel.text = errorMessage
                } else {
                    self?.tableView.isHidden = false
                    self?.errorLabel.isHidden = true
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CommitsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.identifier) as? CommitTableViewCell else {
            fatalError("Can not dequeue CommitTableViewCell")
        }
        
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: CommitTableViewCell, forIndexPath indexPath: IndexPath) {
        
        cell.messageLabel.text = viewModel.commitMessageForIndexPath(indexPath)
        cell.shaLabel.text = viewModel.commitShaForIndexPath(indexPath)
        cell.committerLabel.text = viewModel.committerAndDateForIndexPath(indexPath)
        
        if let avatarURL = viewModel.committerAvatarURLForIndexPath(indexPath) {
            cell.committerAvatar.kf.indicatorType = .activity
            cell.committerAvatar.kf.setImage(with: avatarURL)
        }
        
        cell.webLinkButton.imageView?.contentMode = .scaleAspectFit
        cell.webLinkButton.addTarget(self, action: #selector(openInSafari(_:)), for: .touchUpInside)
    }
}

// MARK: - Actions
extension CommitsViewController {
    
    @objc func openInSafari(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                
            fatalError("Can not get indexPath for selected cell.")
        }
        
        let url = viewModel.gitHubURLForIndexPath(indexPath)
        UIApplication.shared.open(url, options: [:])
    }
}
