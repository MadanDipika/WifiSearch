//
//  SearchViewController.swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import UIKit

struct SearchViewControllerConstants {
    static let cellIdentifier: String = "ResultTableViewCell"
    static let SearchLimit = 50
    
    struct Messages{
        static let searchDefaultPlaceholder = "Search"
    }
}

protocol SearchViewControllerDelegate {
    func search(forString searchString: String, withSearchLimit limit: Int, completion: @escaping ([Result]?, String?)-> Void)
}

class SearchViewController: UITableViewController{
    private var results: [Result]? = nil
    private let searchController = UISearchController(searchResultsController: nil);
    private var searchString: String? = nil
    private var delegate: SearchViewControllerDelegate? = nil
    private var isLoading: Bool = false
    private var pendingSearchTask: DispatchWorkItem? = nil
    private var isFulfillingSearchConditions: Bool{
        get{
            if let searchText = searchController.searchBar.text, searchText != searchString, searchText.count > 0{
                searchString = searchText
                return true
            }else{
                return false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = WikipediaManager()
        
        //setting searchBar on title view of navigation bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.titleView?.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = .clear
        self.tableView.tableFooterView?.isHidden = true
    }
    
    fileprivate func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
            self.searchController.searchBar.placeholder = SearchViewControllerConstants.Messages.searchDefaultPlaceholder
            self.searchString = nil
        }))
        self.dismiss(animated: false) {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? SearchDetailViewController, let cell = sender as? ResultTableViewCell, let indexPath = self.tableView.indexPath(for: cell){
            detailViewController.url = self.results?[indexPath.row].wikiPageURL
        }
    }
    
    private func reloadTableView(show: Bool){
        if show{
        self.results?.removeAll()
        }
        
        self.tableView.tableFooterView?.isHidden = !show
        self.tableView?.reloadData()
    }
}

//Mark: UITableViewDataSource and UITableViewDelegate conformation
extension SearchViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchViewControllerConstants.cellIdentifier) as! ResultTableViewCell
        
        let result = results?[indexPath.row]
        cell.fillResult(result)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if self.isFulfillingSearchConditions{
            pendingSearchTask?.cancel()
            let newSearckTask = DispatchWorkItem{ [weak self] in
                self?.performSearch()
            }
            
            pendingSearchTask = newSearckTask
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: newSearckTask)
        }
    }
    
    func performSearch() {
        guard let searchString = self.searchString else{return}
        
        // search call
        self.delegate?.search(forString: searchString, withSearchLimit: SearchViewControllerConstants.SearchLimit, completion: {[weak self] (results, error) in
            DispatchQueue.main.async {
                if error != nil || results?.count == 0{
                    self?.showError(error: error ?? "No Results Found")
                }else{
                    guard let results = results else{return}
                    self?.results = results
                }
                self?.reloadTableView(show: false)
            }
        })
        
        self.reloadTableView(show: true)
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.isActive = false
        searchBar.placeholder = self.searchString
    }
}

