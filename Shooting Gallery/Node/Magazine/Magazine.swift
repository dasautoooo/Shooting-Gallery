//
//  Magazine.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/16/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation
import SpriteKit

class Magazine {
    var bullets: [Bullet]!
    var capacity: Int!
    
    init(bullets: [Bullet]) {
        self.bullets = bullets
        self.capacity = bullets.count
    }
    
    func needToReload() -> Bool {
        return bullets.allSatisfy { $0.wasShot() == true }
    }
    
    func shoot() {
        bullets.first { (bullet) -> Bool in
            bullet.wasShot() == false
        }?.shoot()
    }
    
    func reloadIfNeeded() {
        if needToReload() {
            for bullet in bullets {
                bullet.reloadIfNeeded()
            }
        }
    }
    
}
