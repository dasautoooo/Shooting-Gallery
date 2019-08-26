//
//  FireButton.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/15/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation
import SpriteKit

class FireButton: SKSpriteNode {
    var isReloading = false
    
    var isPressed = false {
        didSet {
            guard !isReloading else { return }
            if isPressed {
                texture = SKTexture(imageNamed: Texture.fireButtonPressed.imageName)
            } else {
                texture = SKTexture(imageNamed: Texture.fireButtonNormal.imageName)
            }
        }
    }
    
    init() {
        let texture = SKTexture(imageNamed: Texture.fireButtonNormal.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        name = "fire"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
