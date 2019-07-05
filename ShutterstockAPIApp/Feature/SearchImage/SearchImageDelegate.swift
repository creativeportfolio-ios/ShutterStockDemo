//
//  SearchImageDelegate.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import UIKit

protocol SearchImageDelegate: class {
    func finishWithError(_ error:  String?)
    func finishWithSuccess()
}
