//
//  File.swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
   
   
    @IBOutlet var resultImageView: CachedImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    private var result: Result? = nil
    
    func fillResult(_ result: Result?){
        guard let result = result else { return }
        self.result = result

        resultImageView?.loadImage(atURL: result.thumbnailImageURL)
        title?.text = result.title ?? ""
        subtitle?.text = result.subtitle ?? ""
    }
    
    override func prepareForReuse() {
        self.resultImageView?.image = nil
    }
}
