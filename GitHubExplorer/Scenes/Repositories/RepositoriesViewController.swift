//
//  RepositoriesViewController.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 12/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Private Properties
    private let viewModel = RepositoriesViewModel()
    
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
                    
                    self?.viewModel.errorMessage = R.string.localized.repositoriesNoRepositories()
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
        
        viewModel.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension RepositoriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as? RepositoryTableViewCell else {
            fatalError("Can not dequeue RepositoryTableViewCell.")
        }
        
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: RepositoryTableViewCell, forIndexPath indexPath: IndexPath) {
        
        cell.nameLabel.text = viewModel.repositoryNameForIndexPath(indexPath)
        cell.descriptionLabel.text = viewModel.descriptionForIndexPath(indexPath)
        cell.languageLabel.text = viewModel.languageForIndexPath(indexPath)

        cell.commitsButton.imageView?.contentMode = .scaleAspectFit
        cell.releasesButton.imageView?.contentMode = .scaleAspectFit
        cell.webLinkButton.imageView?.contentMode = .scaleAspectFit
        
        cell.webLinkButton.addTarget(self, action: #selector(openInSafari(_:)), for: .touchUpInside)
    }
}

// MARK: - Segues and Actions
extension RepositoriesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let button = sender as? UIButton,
            let cell = button.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let destination = segue.destination as? RepositoryDetails else {
                
            fatalError("Can not get indexPath for selected cell.")
        }
        
        destination.repositoryName = viewModel.repositoryNameForIndexPath(indexPath)
    }

    @objc func openInSafari(_ sender: UIButton) {
        
        guard let cell = sender.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                
            fatalError("Can not get indexPath for selected cell.")
        }
        
        let url = viewModel.gitHubURLForIndexPath(indexPath)
        UIApplication.shared.open(url, options: [:])
    }
}
