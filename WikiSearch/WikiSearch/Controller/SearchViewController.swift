//
//  SearchViewController.swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import UIKit
protocol Result{
    var thumbnailImageURL: URL? {get}
    var highResImageURL: URL? {get}
    var wikiPageURL: URL? {get}
    var title: String? {get}
    var subtitle: String? {get}
}

struct SearchViewControllerConstants {
    static let cellIdentifier: String = "ResultTableViewCell"
}
class SearchViewController: UITableViewController{
    private var results: [Result]? = nil
    private let searchController = UISearchController(searchResultsController: nil);
    private var searchString: String? = nil
    fileprivate var isFulfillingSearchConditions: Bool{
        get{
            if let searchText = searchController.searchBar.text{
                searchString = searchText
                return true
            }else{
                return false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting searchBar on title view of navigation bar
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.titleView?.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    
}

//Mark: UITableViewDataSource and UITableViewDelegate conformation
extension SearchViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 10
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
        if isFulfillingSearchConditions{
            // search call
        }
    }
}

