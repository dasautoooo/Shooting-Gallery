//
//  GameScene.swift
//  I Hate Duck
//
//  Created by Leonard Chen on 8/12/19.
//  Copyright © 2019 Leonard Chan. All rights reserved.
//

import SpriteKit
import GameplayKit

class StageScene: SKScene {
    
    // Nodes
    var rifle: SKSpriteNode?
    var crosshair: SKSpriteNode?
    let fire = FireButton()
    var duckScoreNode: SKNode!
    var targetScoreNode: SKNode!
    var countDown: SKNode!
    
    var magazine: Magazine!
    
    // Touches
    var selectedNodes: [UITouch : SKSpriteNode] = [:]
    
    // Game logic
    var manager: GameManager!
    
    // Game state machine
    var gameStateMachine: GKStateMachine!
       
    // Store the different value of x and y between touch point and crosshair when touchesBegan
    var touchDifferent: (CGFloat, CGFloat)?

    override func didMove(to view: SKView) {
        manager = GameManager(scene: self)
        
        loadUI()
        
        Audio.sharedInstance.playSound(soundFileName: Sound.musicLoop.fileName)
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.volume = 0.3
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.numberOfLoops = -1
        
        gameStateMachine = GKStateMachine(states: [
            ShootingState(fire: fire, magazine: magazine),
            ReloadingState(fire: fire, magazine: magazine),
            ReadyState(fire: fire, magazine: magazine)])

        gameStateMachine.enter(ReadyState.self)
        
        
        manager.activeDucks()
        manager.activeTargets()
    }

}

// MARK: - GameLoop
extension StageScene {
    override func update(_ currentTime: TimeInterval) {
        syncRiflePosition()
        setBoundry()
    }
}

// MARK: - Touches
extension StageScene {
    
    // Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let crosshair = crosshair else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKSpriteNode {
                if !selectedNodes.values.contains(crosshair) && !(node is FireButton) {
                    selectedNodes[touch] = crosshair
                    let xDifference = touch.location(in: self).x - crosshair.position.x
                    let yDifference = touch.location(in: self).y - crosshair.position.y
                    touchDifferent = (xDifference, yDifference)
                }
                
                // Actual shooting
                if node is FireButton {
                    selectedNodes[touch] = fire
                    
                    // Check if is reloading
                    if !fire.isReloading {
                        fire.isPressed = true
                        magazine.shoot()
                        
                        // Play sound
                        Audio.sharedInstance.playSound(soundFileName: Sound.hit.fileName)
                        
                        // Need to reload, enter ReloadingState
                        if magazine.needToReload() {
                            gameStateMachine.enter(ReloadingState.self)
                        }
                        
                        let shootNode = manager.findShootNode(at: crosshair.position)
                        
                        guard let (scoreText, shotImageName) = manager.findTextAndImageName(for: shootNode.name) else {
                            return
                        }

                        // Add shot image
                        manager.addShot(imageNamed: shotImageName, to: shootNode, on: crosshair.position)

                        // Add score text
                        manager.addTextNode(on: crosshair.position, from: scoreText)
                        
                        // Play score sound
                        Audio.sharedInstance.playSound(soundFileName: Sound.score.fileName)
                        
                        // Update score node
                        manager.update(text: String(manager.duckCount * manager.duckScore), node: &duckScoreNode)
                        manager.update(text: String(manager.targetCount * manager.targetScore), node: &targetScoreNode)

                        // Animate shoot node
                        shootNode.physicsBody = nil
                        
                        if let node = shootNode.parent {
                            node.run(.sequence([
                                .wait(forDuration: 0.2),
                                .scaleY(to: 0.0, duration: 0.2)]))
                        }

                    }
                }
            }
        }
    }
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let crosshair = crosshair else { return }
        guard let touchDifferent = touchDifferent else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = selectedNodes[touch] {
                if node.name == "fire" {
                    
                } else {
                    let newCrosshairPosition = CGPoint(x: location.x - touchDifferent.0 , y: location.y - touchDifferent.1)
                    crosshair.position = newCrosshairPosition
                }
            }
        }
    }
    
    // Touch Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if selectedNodes[touch] != nil {
                if let fire = selectedNodes[touch] as? FireButton {
                    fire.isPressed = false
                }
                selectedNodes[touch] = nil
            }
        }
    }
}

// MARK: - Action
extension StageScene {
    func loadUI() {
        // Rifle and Crosshair
        if let scene = scene {
            rifle = childNode(withName: "rifle") as? SKSpriteNode
            crosshair = childNode(withName: "crosshair") as? SKSpriteNode
            crosshair?.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        }
        
        // Add fire button
        fire.position = CGPoint(x: 720, y: 80)
        fire.xScale = 1.7
        fire.yScale = 1.7
        fire.zPosition = 11
        
        addChild(fire)
        
        // Add icons
        let duckIcon = SKSpriteNode(imageNamed: Texture.duckIcon.imageName)
        duckIcon.position = CGPoint(x: 36, y: 365)
        duckIcon.zPosition = 11
        addChild(duckIcon)
        
        let targetIcon = SKSpriteNode(imageNamed: Texture.targetIcon.imageName)
        targetIcon.position = CGPoint(x: 36, y: 325)
        targetIcon.zPosition = 11
        addChild(targetIcon)
        
        // Add score nodes
        duckScoreNode = manager.generateTextNode(from: "0")
        duckScoreNode.position = CGPoint(x: 60, y: 365)
        duckScoreNode.zPosition = 11
        duckScoreNode.xScale = 0.5
        duckScoreNode.yScale = 0.5
        addChild(duckScoreNode)
        
        targetScoreNode = manager.generateTextNode(from: "0")
        targetScoreNode.position = CGPoint(x: 60, y: 325)
        targetScoreNode.zPosition = 11
        targetScoreNode.xScale = 0.5
        targetScoreNode.yScale = 0.5
        addChild(targetScoreNode)
        
        // Add empty magazine
        let magazineNode = SKNode()
        magazineNode.position = CGPoint(x: 760, y: 20)
        magazineNode.zPosition = 11
        
        var bullets = Array<Bullet>()
        
        for i in 0...manager.ammunitionQuantity - 1 {
            let bullet = Bullet()
            bullet.position = CGPoint(x: -30 * i, y: 0)
            magazineNode.addChild(bullet)
            bullets.append(bullet)
        }
        
        magazine = Magazine(bullets: bullets)
        addChild(magazineNode)
    }
    
    func syncRiflePosition() {
        guard let rifle = rifle else { return }
        guard let crosshair = crosshair else { return }
        
        rifle.position.x = crosshair.position.x + 100
    }
    
    func setBoundry() {
        guard let crosshair = crosshair else { return }
        guard let scene = scene else { return }
        
        if crosshair.position.x < scene.frame.minX {
            crosshair.position.x = 0
        }
        
        if crosshair.position.x > scene.frame.maxX {
            crosshair.position.x = scene.frame.maxX
        }
        
        if crosshair.position.y < scene.frame.minY {
            crosshair.position.y = 0
        }
        
        if crosshair.position.y > scene.frame.maxY {
            crosshair.position.y = scene.frame.maxY
        }
    }
}

