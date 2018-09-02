//
//  CachedImageView.Swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import UIKit
class CachedImageView: UIImageView {
    
    func loadImage(atURL url: URL?){
        guard let url = url else {
            self.image = UIImage(named: "noImageAvailable")
            return
        }
        
        if let (_ , data) = CacheManager.shared.cachedResponse(forURL: url), let image = UIImage(data: data){
            self.setImage(image: image)
        }else{
            self.image = UIImage(named: "placeHolder")
            NetworkManager.shared.download(fromURL: url) { [weak self] (data, error) in
                guard error == nil, let data = data, let image = UIImage(data: data)  else{ return }
                
                self?.setImage(image: image)
            }
        }
        
    }
    
    private func setImage(image: UIImage){
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
