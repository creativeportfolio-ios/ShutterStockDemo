//
//  ReachabilityManager.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: NSObject {
    private let reachability = Reachability()
    static let shared = ReachabilityManager()
    var isConnected: Bool = true
    
    override init() {
        super.init()
        startMonitoring()
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .wifi, .cellular:
                isConnected = true
            case .none:
                isConnected = false
            }
        }
    }
    
    func removeNotifire() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}
