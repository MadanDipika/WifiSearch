//
//  NetworkManager.swift
//  WikiSearch
//
//  Created by Dipika Madan on 01/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (Data?, Error?) -> Void

class DownloadTask:  URLSessionTask{
    var completionHandler: RequestCompletionHandler
    init(completionHandler: @escaping RequestCompletionHandler) {
        self.completionHandler = completionHandler
    }
}

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    private var session: URLSession? = nil
    private var downloadTasks = [URL: DownloadTask]()
    
    
    private init(){
        session = URLSession(configuration: .default)
    }
    
    func request(withURL url: URL, completion: @escaping RequestCompletionHandler){
        
        if let (_ , data) = CacheManager.shared.cachedResponse(forURL: url){
            completion(data, nil)
        }else{
            let request = URLRequest(url: url)
            let dataTask = session?.dataTask(with: request, completionHandler: {[weak self] (data, response, error) in
                if self?.isSuccessResponse(response, error) ?? false{
                    CacheManager.shared.cache(response: response, andData: data, forRequest: request)
                    completion(data, nil)
                }else{
                    completion(nil, error)
                }
            })
            
            dataTask?.resume()
        }
    }
    
    
    func download(fromURL url: URL, completion: @escaping RequestCompletionHandler) {
        if let (_ , data) = CacheManager.shared.cachedResponse(forURL: url){
            completion(data, nil)
        }else{
            let request = URLRequest(url: url)
            let downloadTask = session?.downloadTask(with: request, completionHandler: {[weak self] (tempLocalUrl, response, error) in
                
                if self?.isSuccessResponse(response, error) ?? false, let data = self?.dataFrom(tempLocalUrl){
                    CacheManager.shared.cache(response: response, andData: data, forRequest: request)
                    completion(data, nil)
                }else{
                    completion(nil, error)
                }
            })
            downloadTask?.resume()
        }
    }
    
    private func isSuccessResponse(_ response: URLResponse?,_ error: Error?)-> Bool{
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse{
            switch httpResponse.statusCode{
            case 200...202:
                return true
            default:
                return false
            }
        }else{
            return false
        }
    }
    
    private func dataFrom(_ tempLocalUrl: URL?) -> Data!{
        guard let tempLocalUrl = tempLocalUrl else{
            return nil
        }
        
        do{
            let data = try Data(contentsOf: tempLocalUrl)
            return data
        }catch{
            return nil
        }
    }
}

