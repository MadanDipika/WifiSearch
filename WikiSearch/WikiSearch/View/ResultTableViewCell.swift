//
//  File.swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    private var result: Result? = nil
    
    func fillResult(_ result: Result?){
        // guard let result = result else { return }
        
        self.result = result
        if let thumbnailImageURL = result?.thumbnailImageURL{
            self.resultImageView?.image = UIImage(named: "placeHolder")
        }
        
        self.resultImageView?.image = UIImage(named: "placeHolder")
        title?.text = result?.title ?? "Test"
        subtitle?.text = result?.subtitle ?? "Testing"
    }
    
    override func prepareForReuse() {
        //self.resultImageView?.image = nil
    }
}
