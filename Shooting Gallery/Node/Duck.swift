//
//  Duck.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/12/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation
import SpriteKit

class Duck: SKNode {
    var hasTarget: Bool!
    
    init(hasTarget: Bool = false) {
        super.init()
        
        self.hasTarget = hasTarget
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
