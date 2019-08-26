//
//  Sound.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/22/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation

enum Sound: String {
    case musicLoop = "Cheerful Annoyance.wav"
    case hit = "hit.wav"
    case reload = "reload.wav"
    case score = "score.wav"
    
    var fileName: String {
        return rawValue
    }
}
