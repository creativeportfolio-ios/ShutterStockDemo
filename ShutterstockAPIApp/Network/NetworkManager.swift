//
//  NetworkManager.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Foundation
import BrightFutures
import Alamofire
import RappleProgressHUD
import CodableAlamofire

enum NetworkError: Error {
    case notFound
    case unauthorized
    case forbidden
    case nonRecoverable
    case internetConnectionError
    case errorString(String?)
    case unprocessableEntity(String?)
    case other(Error)
}

struct NetworkManager {
    
    static func networkQueue() -> DispatchQueue {
         return DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "com.ShutterstockAPIApp").networking-queue", attributes: .concurrent)
    }
    
    static func makeRequest<T: Decodable>(_ urlRequest: URLRequestConvertible, message: String, showProgress: Bool,
                                         showLog: Bool = false) ->
        Future<T, NetworkError> {
            let promise = Promise<T, NetworkError>()
           
            DispatchQueue.main.async() {
                if (showProgress == true) {
                    let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle.apple)
                    RappleActivityIndicatorView.startAnimatingWithLabel(message, attributes: attributes)
                }
            }
            
            Alamofire.request(urlRequest)
                .validate()
                .responseDecodableObject(queue: NetworkManager.networkQueue(), completionHandler: { (response: DataResponse<T>)-> Void in
                    
                    if (showProgress == true) {
                        DispatchQueue.main.async() {
                            RappleActivityIndicatorView.stopAnimation()
                        }
                    }
                    switch response.result {
                    case .success:
                        promise.success(response.result.value!)
                        
                    case .failure
                        where response.response?.statusCode == HTTPStatusCodes.BadRequest.rawValue:
                        var jsonData: String?
                        if let data = response.data {
                            jsonData = String(data: data, encoding: .utf8)
                        }
                        promise.failure(.errorString(jsonData))
                        
                    case .failure
                        where response.response?.statusCode == HTTPStatusCodes.Unauthorized.rawValue:
                        promise.failure(.unauthorized)
                        
                    case .failure
                        where response.response?.statusCode == HTTPStatusCodes.Forbidden.rawValue:
                        promise.failure(.forbidden)
                        
                    case .failure
                        where response.response?.statusCode == HTTPStatusCodes.NotFound.rawValue:
                        promise.failure(.notFound)
                        
                    case .failure
                        where response.response?.statusCode == HTTPStatusCodes.UnprocessableEntity.rawValue:
                        var jsonData: String?
                        
                        if let data = response.data {
                            jsonData = String(data: data, encoding: .utf8)
                        }
                        promise.failure(.unprocessableEntity(jsonData))
                        
                    case .failure
                        where response.response?.statusCode == HTTPStatusCodes.InternalServerError.rawValue:
                        promise.failure(.nonRecoverable)
                        
                    case .failure:
                        promise.failure(.other(response.error!))
                    }
            })
            
            return promise.future
    }
}

