//
//  ActionKey.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/15/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation

enum ActionKey: String {
    case reloading
    case countDown
    
    var key: String {
        return rawValue
    }
}
