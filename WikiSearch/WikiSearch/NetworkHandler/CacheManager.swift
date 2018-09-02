//
//  CacheManager.Swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import Foundation

class CacheManager{
    static let shared: CacheManager = CacheManager()
    
    private init(){}
    
    func cachedResponse(forURL url: URL) -> (response: URLResponse, data: Data)? {
        let request = URLRequest(url: url)
        if let cachedURLResponse = URLCache.shared.cachedResponse(for: request){
            return (cachedURLResponse.response, cachedURLResponse.data)
        }else{
            return nil
        }
    }
    
    func cache(response: URLResponse?, andData data: Data?, forRequest request: URLRequest){
        if let response = response, let data = data{
            let cachedURLResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowed)
            URLCache.shared.storeCachedResponse(cachedURLResponse, for: request)
        }
    }
}
