//
//  WikipediaResult.swift
//  WikiSearch
//
//  Created by Dipika Madan on 02/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import Foundation

struct WikipediaResult: Result {
    
    var thumbnailImageURL: URL?
    var title: String?
    var subtitle: String?
    var highResImageURL: URL?
    var wikiPageURL: URL? {
        get{
            if let encodedTitle = encodedTitle{
                return URL(string: "https://en.wikipedia.org/wiki/\(encodedTitle)")
            }else{
                return nil
            }
        }
    }
    var encodedTitle: String? {
        get{
            return title?.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        }
    }
}
