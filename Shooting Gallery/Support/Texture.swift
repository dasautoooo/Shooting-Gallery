//
//  Textrue.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/16/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation
import SpriteKit

enum Texture: String {
    case bulletTexture = "icon_bullet"
    case bulletEmptyTexture = "icon_bullet_empty"
    case fireButtonReloading = "fire_reloading"
    case fireButtonNormal = "fire_normal"
    case fireButtonPressed = "fire_pressed"
    case duckIcon = "icon_duck"
    case targetIcon = "icon_target"
    case shotblue = "shot_blue"
    case shotBrown = "shot_brown"
    
    var imageName: String {
        return rawValue
    }
}
