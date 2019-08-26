//
//  GameManager.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/22/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import Foundation
import SpriteKit

class GameManager {
    unowned var scene: SKScene!
    
    // Score
    var totalScore = 0
    let targetScore = 10
    let duckScore = 10
    
    // Count
    var duckCount = 0
    var targetCount = 0
    
    var duckMoveDuration: TimeInterval!
    
    let targetXPosition: [Int] = [160, 240, 320, 400, 480, 560, 640]
    var usingTargetXPosition = Array<Int>()
    
    // The amount of ammunition
    var ammunitionQuantity = 5
 
    var zPositionDecimal = 0.001 {
        didSet {
            if zPositionDecimal == 1 {
                zPositionDecimal = 0.001
            }
        }
    }
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func generateDuck(hasTarget: Bool = false) -> Duck {
        var duck: SKSpriteNode
        var stick: SKSpriteNode
        var duckImageName: String
        var duckNodeName: String
        var node = Duck()
        var texture = SKTexture()
        
        if hasTarget {
            duckImageName = "duck_target/\(Int.random(in: 1...3))"
            texture = SKTexture(imageNamed: duckImageName)
            duckNodeName = "duck_target"
            node = Duck(hasTarget: true)
        } else {
            duckImageName = "duck/\(Int.random(in: 1...3))"
            texture = SKTexture(imageNamed: duckImageName)
            duckNodeName = "duck"
            node = Duck()
        }
        
        duck = SKSpriteNode(texture: texture)
        duck.name = duckNodeName
        duck.position = CGPoint(x: 0, y: 140)
        
        let physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: texture.size())
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        duck.physicsBody = physicsBody
        
        stick = SKSpriteNode(imageNamed: "stick/\(Int.random(in: 1...2))")
        stick.anchorPoint = CGPoint(x: 0.5, y: 0)
        stick.position = CGPoint(x: 0, y: 0)
        
        duck.xScale = 0.8
        duck.yScale = 0.8
        stick.xScale = 0.8
        stick.yScale = 0.8
        
        node.addChild(stick)
        node.addChild(duck)
        
        
        return node
    }
    
    func generateTarget() -> Target {
        var target: SKSpriteNode
        var stick: SKSpriteNode
        let node = Target()
        let texture = SKTexture(imageNamed: "target/\(Int.random(in: 1...3))")
        
        target = SKSpriteNode(texture: texture)
        
        stick = SKSpriteNode(imageNamed: "stick_metal")
        
        target.xScale = 0.5
        target.yScale = 0.5
        target.position = CGPoint(x: 0, y: 95)
        target.name = "target"
        stick.xScale = 0.5
        stick.yScale = 0.5
        stick.anchorPoint = CGPoint(x: 0.5, y: 0)
        stick.position = CGPoint(x: 0, y: 0)
        
        node.addChild(stick)
        node.addChild(target)
        
        
        
        return node
    }
    
    func activeDucks() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let duck = self.generateDuck(hasTarget: Bool.random())
            duck.position = CGPoint(x: -10, y: Int.random(in: 60...90))
            duck.zPosition = Int.random(in: 0...1) == 0 ? 4 : 6
            duck.zPosition = duck.zPosition + CGFloat(self.zPositionDecimal)
            self.zPositionDecimal += 0.001
            
            self.scene.addChild(duck)
            
            if duck.hasTarget {
                self.duckMoveDuration = TimeInterval(Int.random(in: 2...4))
            } else {
                self.duckMoveDuration = TimeInterval(Int.random(in: 5...7))
            }
            
            duck.run(.sequence([
                .moveTo(x: 850, duration: self.duckMoveDuration),
                .removeFromParent()]))
        }
    }
    
    func activeTargets() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            let target = self.generateTarget()
            var xPosition = self.targetXPosition.randomElement()!
            
            while self.usingTargetXPosition.contains(xPosition) {
                xPosition = self.targetXPosition.randomElement()!
            }
            
            self.usingTargetXPosition.append(xPosition)
            target.position = CGPoint(x: xPosition, y: Int.random(in: 120...145))
            target.zPosition = 1
            target.yScale = 0
            self.scene.addChild(target)
            
            let physicsBody = SKPhysicsBody(circleOfRadius: 71/2)
            physicsBody.affectedByGravity = false
            physicsBody.isDynamic = false
            physicsBody.allowsRotation = false
            
            target.run(.sequence([
                .scaleY(to: 1, duration: 0.2),
                .run {
                    if let node = target.childNode(withName: "target") {
                        node.physicsBody = physicsBody
                    }
                },
                .wait(forDuration: TimeInterval(Int.random(in: 3...6))),
                .scaleY(to: 0, duration: 0.2),
                .removeFromParent(),
                .run {
                    self.usingTargetXPosition.remove(at: self.usingTargetXPosition.firstIndex(of: xPosition)!)
                }]))
            
        }
    }
    
    func generateTextNode(from text: String, leadingAnchorPoint: Bool = true) -> SKNode {
        let node = SKNode()
        var width: CGFloat = 0.0
        
        for character in text {
            var characterNode = SKSpriteNode()
            
            if character == "0" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.zero.textureName)
            } else if character == "1" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.one.textureName)
            } else if character == "2" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.two.textureName)
            } else if character == "3" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.three.textureName)
            } else if character == "4" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.four.textureName)
            } else if character == "5" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.five.textureName)
            } else if character == "6" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.six.textureName)
            } else if character == "7" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.seven.textureName)
            } else if character == "8" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.eight.textureName)
            } else if character == "9" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.nine.textureName)
            } else if character == "+" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.plus.textureName)
            } else if character == "*" {
                characterNode = SKSpriteNode(imageNamed: ScoreNumber.multiplication.textureName)
            } else {
                continue
            }
            
            node.addChild(characterNode)
            
            characterNode.anchorPoint = CGPoint(x: 0, y: 0.5)
            characterNode.position = CGPoint(x: width, y: 0.0)
            
            width += characterNode.size.width
        }
        
        if leadingAnchorPoint {
            return node
        } else {
            let anotherNode = SKNode()
            
            anotherNode.addChild(node)
            node.position = CGPoint(x: -width/2, y: 0)
            
            return anotherNode
        }
        
    }
    
    func update(text: String, node: inout SKNode, leadingAnchorPoint: Bool = true) {
        let position = node.position
        let zPositon = node.zPosition
        let xScale = node.xScale
        let yScale = node.yScale
        
        node.removeFromParent()
        
        node = generateTextNode(from: text, leadingAnchorPoint: leadingAnchorPoint)
        node.position = position
        node.zPosition = zPositon
        node.xScale = xScale
        node.yScale = yScale
        
        scene.addChild(node)
    }
    
    func findShootNode(at position: CGPoint) -> SKSpriteNode {
        var shootNode = SKSpriteNode()
        var biggestZPosition: CGFloat = 0.0
        
        // Find the node which crosshair is landed
        scene.physicsWorld.enumerateBodies(at: position) { (body, pointer) in
            guard let node = body.node as? SKSpriteNode else { return }
            
            if node.name == "duck" || node.name == "duck_target" || node.name == "target" {
                if let parentNode = node.parent {
                    if parentNode.zPosition > biggestZPosition {
                        biggestZPosition = parentNode.zPosition
                        shootNode = node
                    }
                }
            }
        }
        
        return shootNode
    }
    
    func findTextAndImageName(for nodeName: String?) -> (String, String)? {
        var scoreText = ""
        var shotImageName = ""
        
        switch nodeName {
        case "duck":
            scoreText = "+\(duckScore)"
            totalScore += duckScore
            duckCount += 1
            shotImageName = Texture.shotblue.imageName
        case "duck_target":
            scoreText = "+\(duckScore + targetScore)"
            totalScore += duckScore + targetScore
            duckCount += 1
            targetCount += 1
            shotImageName = Texture.shotblue.imageName
        case "target":
            scoreText = "+\(targetScore)"
            totalScore += targetScore
            targetCount += 1
            shotImageName = Texture.shotBrown.imageName
        default:
            return nil
        }
        
        return (scoreText, shotImageName)
    }
    
    func addShot(imageNamed imageName: String, to node: SKSpriteNode, on position: CGPoint) {
        let convertedPosition = scene.convert(position, to: node)
        let shot = SKSpriteNode(imageNamed: imageName)
        
        shot.position = convertedPosition
        node.addChild(shot)
        shot.run(.sequence([
            .wait(forDuration: 2),
            .fadeAlpha(to: 0.0, duration: 0.3),
            .removeFromParent()]))
    }
    
    func addTextNode(on position: CGPoint, from text: String) {
        let scorePosition = CGPoint(x: position.x + 10, y: position.y + 30)
        let scoreNode = generateTextNode(from: text)
        scoreNode.position = scorePosition
        scoreNode.zPosition = 9
        scoreNode.xScale = 0.5
        scoreNode.yScale = 0.5
        scene.addChild(scoreNode)
        scoreNode.run(.sequence([
            .wait(forDuration: 0.5),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()]))
    }
}
