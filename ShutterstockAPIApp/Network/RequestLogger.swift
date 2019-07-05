//
//  RequestLogger.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Alamofire
import Foundation

open class RequestLogger {
    public var enabled: Bool = Environment.isDebug()
    public var leval: Level
    public var logHTMLResponse : Bool = false
    
    private let queue: DispatchQueue = DispatchQueue(label: "Logger.log")
    private let observerQueue: OperationQueue = OperationQueue()
    
    public init(leval: Level = .debug) {
        self.leval = leval
    }
    
    public func startLogging() {
        endLogging()
        if self.enabled {
            beginLogging()
        }
    }
    
    deinit {
        endLogging()
    }
    
    static func configuration() {
        let logger = RequestLogger(leval: Level.verbose)
        logger.logHTMLResponse = true
        logger.startLogging()
    }
}

extension RequestLogger {
    private func beginLogging() {
        NotificationCenter.default.addObserver(forName: Notification.Name.Task.DidComplete, object: nil, queue: self.observerQueue) { notification in
            self.parse(notification)
        }
    }
    
    private func endLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func parse(_ notification: Notification) {
        guard let sessionDelegate = notification.object as? SessionDelegate,
            let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask else { return }
        
        switch self.leval {
        case .verbose:
            var logString: String = "Request \(task.taskIdentifier) : \n\(task.originalRequest?.string ?? "")\n"
            
            logString += "\n\(task.originalRequest?.curlString ?? "")\n"
            
            if let error = task.error {
                logString += "\nResponse ERROR : \(error.localizedDescription)"
                if let response = task.response as? HTTPURLResponse {
                    logString += "\nstatusCode : \(response.statusCode)"
                }
            } else {
                if let response = task.response as? HTTPURLResponse {
                    logString += "\nResponse :"
                    logString += "\nstatusCode : \(response.statusCode)"
                    logString += "\nmimeType : \(response.mimeType ?? "")"

                    if let mimeType : String = response.mimeType, mimeType == MimeType.html.rawValue{
                        logString += "\nData : HTML (for print html responce enable logHTMLResponse to true)"
                        log(logString)
                        break
                    }
                }
                
                if let data = sessionDelegate[task]?.delegate.data {
                    logString += "\nData :\n"
                    logString += prettyPrint(with: data)
                }
            }
            
            log(logString)
            break
        case .debug:
            var logString: String = "Request \(task.taskIdentifier): \n\(task.originalRequest?.string ?? "")\n"
            
            if let error = task.error {
                logString += "\nResponse ERROR : \(error.localizedDescription)"
                if let response = task.response as? HTTPURLResponse {
                    logString += "\nstatusCode : \(response.statusCode)"
                }
            } else {
                if let response = task.response as? HTTPURLResponse {
                    logString += "\nResponse :"
                    logString += "\nstatusCode : \(response.statusCode)"
                    logString += "\nmimeType : \(response.mimeType ?? "")"
                }
            }
            
            log(logString)
            break
        case .error:
            
            if let error = task.error {
                var logString: String = "Request \(task.taskIdentifier): \n\(task.originalRequest?.string ?? "")\n"
                
                logString += "\nResponse ERROR : \(error.localizedDescription)"
                
                if let response = task.response as? HTTPURLResponse {
                    logString += "\nstatusCode : \(response.statusCode)"
                    logString += "\nmimeType : \(response.mimeType ?? "")"
                }
                
                log(logString)
            }
            
            break
        }
    }
}

extension RequestLogger {
    private func log(_ message: String) {
        self.queue.async {
            print("--------------------------------------------------------")
            print(message)
            print("--------------------------------------------------------")
        }
    }
    
    /// Convert to JSON String
    ///
    /// - Parameter json: data
    /// - Returns: jsonstring
    func prettyPrint(with data: Data) -> String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            if let prettyString: String = String(data: prettyData, encoding: .utf8) {
                return prettyString
            }
        } catch {
            if let string: String = String(data: data, encoding: .utf8) {
                return string
            }
        }
        return ""
    }
}

public enum Level {
    case verbose, debug, error
    
    var description: String {
        return String(describing: self).uppercased()
    }
}

extension Level: Comparable {}

public func ==(x: Level, y: Level) -> Bool {
    return x.hashValue == y.hashValue
}

public func <(x: Level, y: Level) -> Bool {
    return x.hashValue < y.hashValue
}

extension URLRequest {
    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
    public var string: String {
        guard let url = url else { return "" }
        
        var command: [String] = []
        command.append("URL : \(url.absoluteString)")
        if let method = httpMethod {
            command.append("httpMethod : \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("HTTPHeader : \(key): \(value)")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("httpBody: \(body)")
        }
        
        return command.joined(separator: "\n")
    }
}

enum MimeType : String {
    case html = "text/html"
    case json = "application/json"
}
