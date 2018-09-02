//
//  Result.swift
//  WikiSearch
//
//  Created by Dipika Madan on 02/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import Foundation

protocol Result{
    var thumbnailImageURL: URL? {get}
    var highResImageURL: URL? {get}
    var wikiPageURL: URL? {get}
    var title: String? {get}
    var subtitle: String? {get}
}
