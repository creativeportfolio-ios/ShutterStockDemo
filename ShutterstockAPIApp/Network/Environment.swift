//
//  Environment.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import UIKit

struct Environment {
    private static let production: Bool = {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }()
    
    static func isProduction() -> Bool {
        return self.production
    }
    
    static func isDebug() -> Bool {
        return !self.production
    }
    
    static func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
