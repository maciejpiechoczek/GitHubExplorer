//
//  ReleasesViewController.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 12/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit
import Kingfisher

class ReleasesViewController: UIViewController, RepositoryDetails {
    
    // MARK: Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Private Properties
    private let viewModel = ReleasesViewModel()
    
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
                    
                    self?.viewModel.errorMessage = R.string.localized.releasesNoReleases()
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
extension ReleasesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReleaseTableViewCell.identifier) as? ReleaseTableViewCell else {
            fatalError("Can not dequeue ReleaseTableViewCell")
        }
        
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: ReleaseTableViewCell, forIndexPath indexPath: IndexPath) {
        
        cell.nameLabel.text = viewModel.releaseNameForIndexPath(indexPath)
        cell.tagLabel.text = viewModel.releaseTagForIndexPath(indexPath)
        cell.authorLabel.text = viewModel.authorAndDateForIndexPath(indexPath)
        
        if let avatarURL = viewModel.authorAvatarURLForIndexPath(indexPath) {
            cell.authorAvatar.kf.indicatorType = .activity
            cell.authorAvatar.kf.setImage(with: avatarURL)
        }
        
        cell.webLinkButton.imageView?.contentMode = .scaleAspectFit
        cell.webLinkButton.addTarget(self, action: #selector(openInSafari(_:)), for: .touchUpInside)
    }
}

// MARK: - Actions
extension ReleasesViewController {
    
    @objc func openInSafari(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                
                fatalError("Can not get indexPath for selected cell.")
        }
        
        let url = viewModel.gitHubURLForIndexPath(indexPath)
        UIApplication.shared.open(url, options: [:])
    }
}
