//
//  HttpRouter.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import UIKit
import Alamofire

public enum HttpRouter: URLRequestConvertible {
    
    static let baseURL: String = "https://api.shutterstock.com/v2/"
    
    case imagesSearch(page: Int, query: String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .imagesSearch:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .imagesSearch:
            return "images/search"
        }
    }
    
    var jsonParameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var urlParameters: [String: Any]? {
        switch self {
        case .imagesSearch(let page, let query):
            return ["page": page, "query": query]
        }
    }
    
    var headerFields: [String: String]? {
        switch self {
        case .imagesSearch:
            return ["Authorization": "Bearer v2/ZTk3YzktMGUzZjMtOGYzYjQtNzE0YWUtZjNjMWQtODk1OTYvMjM3OTM1NzE3L2N1c3RvbWVyLzMvTmFOdDJET0hSQko4ZHlDWjNPOXQ1R1k1Njg2MWdCQ1g1WGEyajB1VjZMM3YzeHlHaHRJTlQ0QTZxVkhWQzdLWm1GbGFhemhkOUJTMVpHd2ZydnZzQkdwOUhZSWd3OW1mNFgwSjdXYzllM2FhdjVTZjNTY3BmanYwWEJMT3lPLWtrNkF3OTJrTS0zazgwS0syaTVyTlQzTHY5ZTZkNlBPWVJ4MHEya3JCNVJuM08tbXZPT1dIVmhSbm5nWFMwQjhiY1c0RXdMUzlpdlhxd1NEd2l1NWc1dw"]
        }
    }
    
    var useBaseUrl: Bool? {
        switch self {
        default:
            return true
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = self.useBaseUrl! ? URL.init(string: HttpRouter.baseURL + path) : URL.init(string: self.path)
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        
        if self.useBaseUrl! {
            urlRequest.allHTTPHeaderFields = headerFields
        }
        
        switch self {
        case .imagesSearch:
            return try URLEncoding.queryString.encode(urlRequest, with: self.urlParameters)
        }
    }
}
