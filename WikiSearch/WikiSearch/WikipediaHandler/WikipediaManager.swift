//
//  WikiManager.swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import Foundation

private struct WikipediaConstants{
    static let baseURL = "https://en.wikipedia.org//"
    static let relativeURL = "w/api.php?"
    static let mendatoryParamsString = "action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&wbptterms=description&"
    static let query = "query"
    static let pages = "pages"
    static let title = "title"
    static let thumbnail = "thumbnail"
    static let source = "source"
    static let terms = "terms"
    static let description = "description"
    
    struct Messages {
        static let searchURLCreationFailed = "Failed to create search URL."
        static let parsingFailed = "Found faulty response!"
        static let networtError = "Something went wrong!"
    }
}

class WikipediaManager: SearchViewControllerDelegate {
    
    func search(forString searchString: String, withSearchLimit limit: Int, completion: @escaping ([Result]?, String?)-> Void){
        guard let searchURL = searchURL(forString: searchString, withSearchLimit: limit) else{
            completion(nil, WikipediaConstants.Messages.searchURLCreationFailed)
            return
        }
        
        NetworkManager.shared.request(withURL: searchURL, completion:{[weak self] (data, error) in
            if let _ = error {
                completion(nil, WikipediaConstants.Messages.networtError)
            }else{
                if let results = self?.parseSearchResult(data){
                    completion(results, nil)
                }else{
                    completion(nil, WikipediaConstants.Messages.parsingFailed)
                }
            }
        })
    }
    
    private func searchURL(forString searchString: String, withSearchLimit limit: Int) -> URL?{
        
        guard let escapedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let URLString = "\(WikipediaConstants.baseURL)\(WikipediaConstants.relativeURL)\(WikipediaConstants.mendatoryParamsString)&gpssearch=\(escapedSearchString)&gpslimit=\(limit)"
        
        guard let url = URL(string: URLString) else { return nil }
        
        return url
    }
    
    private func parseSearchResult(_ data: Data?) -> [Result]?{
        guard let data = data else{return nil}
        
        do {
            guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                let query = resultsDictionary[WikipediaConstants.query] as? [String: AnyObject], let pages = query[WikipediaConstants.pages] as? [AnyObject] else {return nil}
            
            var results = [Result]()
            
            for page in pages{
                var result = Result()
                
                result.title = page[WikipediaConstants.title] as? String
                
                if let thumbnail = page[WikipediaConstants.thumbnail] as? [String: AnyObject], let thumbnailString = thumbnail[WikipediaConstants.source] as? String, let thumbnailImageURL = URL(string: thumbnailString){
                    result.thumbnailImageURL = thumbnailImageURL
                }
                
                if let terms = page[WikipediaConstants.terms] as? [String: AnyObject], let descriptions = terms[WikipediaConstants.description] as? [String]{
                    result.subtitle = descriptions[0]
                }
                
                results.append(result)
            }
            return results
        } catch _ {
            return nil
        }
    }
}
