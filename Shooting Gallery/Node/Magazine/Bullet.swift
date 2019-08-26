//
//  Bullet.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/15/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    private var isEmpty = true

    init() {
        let texture = SKTexture(imageNamed: Texture.bulletEmptyTexture.imageName)

        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloaded() {
        isEmpty = false
    }
    
    func shoot() {
        isEmpty = true
        texture = SKTexture(imageNamed: Texture.bulletEmptyTexture.imageName)
    }
    
    func wasShot() -> Bool {
        return isEmpty
    }
    
    func reloadIfNeeded() {
        if isEmpty {
            texture = SKTexture(imageNamed: Texture.bulletTexture.imageName)
            isEmpty = false
        }
    }
}
