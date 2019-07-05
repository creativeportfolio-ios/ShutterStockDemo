//
//  SearchImageRepository.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import UIKit
import BrightFutures

struct SearchImageRepository {

    typealias CompletionBlock = (_ success: NetworkError?, _ response: SearchImageDetails?) -> Void
    
    func getSearchImages(_ page: Int, query: String, completion: @escaping CompletionBlock) {
        
        let future: Future<SearchImageDetails, NetworkError> = NetworkManager.makeRequest(HttpRouter.imagesSearch(page: page, query: query), message: "loading...", showProgress: true)
        
        future.onSuccess { (response) in
            completion(nil, response)
        }
        
        future.onFailure { error in
            completion(error, nil)
        }
    }
}
