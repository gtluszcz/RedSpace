//
//  normalAsteroid.swift
//  Space
//
//  Created by Henryk on 21.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Asteroid: SKSpriteNode{
    
    //MARK: PROPERTIES
    var game: GameScene!
    var maxhealth: CGFloat!
    var currenthealth: CGFloat!
    var kind: Int!
    
    //MARK: - INIT
    init(scene: GameScene, kind: Int, position: CGPoint){
        let texture = SKTexture(imageNamed: "Meteor\(kind)v4")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup(kind: kind, position: position)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(kind: Int, position: CGPoint){
        //set properties
        self.position = position
        self.zPosition = 1
        
        
        
        //append to groups
        self.game.asteroids.append(self)
        
        
        //set health and kind
        self.kind = kind
        switch kind {
        case 1:
            self.maxhealth = 271
        case 3:
            self.maxhealth = 223
        case 4:
            self.maxhealth = 233
        case 5:
            self.maxhealth = 52
        case 6:
            self.maxhealth = 57
        case 7:
            self.maxhealth = 22
        case 8:
            self.maxhealth = 23
        case 9:
            self.maxhealth = 9
        case 10:
            self.maxhealth = 7
        default:
            self.maxhealth = 0
        }
        self.currenthealth = self.maxhealth
        
        //define physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: max(self.size.width,self.size.height) / 2 * 0.9)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Player | PhysicsCategory.Planet
        self.physicsBody?.isResting = true
        self.physicsBody?.fieldBitMask = PhysicsCategory.Explosion | PhysicsCategory.PartitionPush
        
        
        /// Testing kind textbox
//        let textbox = SKLabelNode(text: String(Int(self.kind)))
//        textbox.fontSize = 20
//        textbox.zPosition = 99
//        textbox.fontColor = UIColor.white
//        textbox.horizontalAlignmentMode = .center
//        textbox.verticalAlignmentMode = .center
//        self.addChild(textbox)

        
    }
    //MARK: - FUNCTIONALITY
    func changechunks(){
        if self.physicsBody?.velocity != CGVector(dx: 0, dy: 0){
            let oldvelocity = self.physicsBody?.velocity
            let oldangularvelocity = self.physicsBody?.angularVelocity
            let oldchunk = self.parent as! Chunk
            if self.position.x > oldchunk.size.width / 2{
                var changed = false
                for chunk in self.game.chunks{
                    if chunk.intersects(self) && chunk.position.y == oldchunk.position.y && chunk != oldchunk && chunk.position.x > oldchunk.position.x{
                        changed = true
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.x = (oldchunk.size.width / -2) + self.position.x - oldchunk.size.width / 2

                        
                    }
                }
                if !changed{
                    disappear()
                }
                
            }
            else if self.position.x < oldchunk.size.width / -2{
                var changed = false
                for chunk in self.game.chunks{
                    if  chunk.intersects(self) && chunk.position.y == oldchunk.position.y && chunk != oldchunk && chunk.position.x < oldchunk.position.x{
                        changed = true
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.x = (oldchunk.size.width / 2) + self.position.x - oldchunk.size.width / -2
                    }
                }
                if !changed{
                    disappear()
                }
                
            }
            else if self.position.y > oldchunk.size.height / 2{
                var changed = false
                for chunk in self.game.chunks{
                    if chunk.intersects(self) && chunk.position.x == oldchunk.position.x && chunk != oldchunk && chunk.position.y > oldchunk.position.y{
                        changed = true
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.y = (oldchunk.size.height / -2) + self.position.y - oldchunk.size.height / 2
                        
                    }
                }
                if !changed{
                    disappear()
                }
            }
            else if self.position.y < oldchunk.size.height / -2{
                var changed = false
                for chunk in self.game.chunks{
                    if chunk.intersects(self) && chunk.position.x == oldchunk.position.x && chunk != oldchunk && chunk.position.y < oldchunk.position.y{
                        changed = true
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.y = (oldchunk.size.height / 2) + self.position.y - oldchunk.size.height / -2


                    }
                }
                if !changed{
                    disappear()
                }
            }
        }
    }
    
    func makepush(point: CGPoint, size: CGSize){

        let push = SKFieldNode.radialGravityField()
        push.position.x = point.x + (self.parent?.position.x)!
        push.position.y = point.y + (self.parent?.position.y)!

        push.strength = -0.2
        push.categoryBitMask = PhysicsCategory.PartitionPush
        push.region = SKRegion(radius: Float(CGFloat(1) / CGFloat(2) * max(self.size.height,self.size.width) + 10))
        push.falloff = 1
        push.run(SKAction.sequence([
            SKAction.strength(to: 0, duration: 0.1),
            SKAction.removeFromParent()
            ]))
        self.game.addChild(push)
    }
    
    func makepuff(){
        let puff = SKEmitterNode(fileNamed: "Explode1")
        let pos = CGPoint(x: self.position.x + (self.parent?.position.x)!, y: self.position.y + (self.parent?.position.y)!)
        puff?.position = pos
        puff?.zPosition = 2
        self.game.addChild(puff!)
        let disappear = SKAction.removeFromParent()
        let delay = SKAction.wait(forDuration: TimeInterval(1))
        let doStuff = SKAction.sequence([delay,disappear])
        puff?.run(doStuff)
    }
    
    func addasteroidsofkind(table: [Int]){
        let rs = GKARC4RandomSource()
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: -3, highestValue: 3)
        
        for num in table{
            let point = CGPoint(x: self.position.x + CGFloat(rd.nextInt()), y: self.position.y + CGFloat(rd.nextInt()))
            let asteroid = Asteroid(scene: self.game, kind: num, position: point)
            self.parent?.addChild(asteroid)

        }
    }
    
    func partition(){
        if self.currenthealth <= 0{
            switch self.kind {
            case 1:
                
                let asteroidsToCreate = [10, 6, 5, 7, 5, 8, 9, 7]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break
            case 3:
    
                let asteroidsToCreate = [10, 6, 5, 9, 9, 7]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break

            case 4:
                
                let asteroidsToCreate = [10, 5, 5, 5, 10, 10]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break
                
            case 5:
                
                let asteroidsToCreate = [10, 9, 7]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break
                
            case 6:
                
                let asteroidsToCreate = [9, 7]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break
                
            case 7:
                let asteroidsToCreate = [9]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break

            case 8:
                let asteroidsToCreate = [10]
                makepush(point: self.position, size: self.size)
                addasteroidsofkind(table: asteroidsToCreate)
                makepuff()
                disappear()
                break

            case 9:
                makepuff()
                disappear()
              
                
                break
            case 10:
                makepuff()
                disappear()
            
                break
            default:
                print("<Error> Unable to partition meteor of kind \(self.kind)")
                disappear()
            }
        }
    }
    
    func damage(damage: CGFloat){
        (currenthealth)!-=damage;
        if self.game.debug{
            indicatedamage(damage: damage)
        }
        


    }
    
    func indicatedamage(damage: CGFloat){
        let textbox = SKLabelNode(fontNamed: "Avenir-Black")
        textbox.text = String(Int(damage))
        textbox.fontSize = 16
        textbox.zPosition = 99
        textbox.fontColor = UIColor.white
        textbox.horizontalAlignmentMode = .center
        textbox.verticalAlignmentMode = .center
        self.game.addChild(textbox)
        let chunk = self.parent as! Chunk
        textbox.position.x = self.position.x + chunk.gridPos.x*chunk.size.width
        textbox.position.y = self.position.y + chunk.gridPos.y*chunk.size.height
        let disappear = SKAction.removeFromParent()
        let moveup = SKAction.moveTo(y: self.position.y + chunk.gridPos.y*chunk.size.height + CGFloat(100), duration: TimeInterval(2))
        let fadeout = SKAction.fadeOut(withDuration: TimeInterval(2))
        let group = SKAction.group([moveup,fadeout])
        let doStuff = SKAction.sequence([group,disappear])
        textbox.run(doStuff)
    }

    
    func disappear(){
        self.game.asteroids.remove(at: self.game.asteroids.index(of: self)!)
        self.removeFromParent()
    }

    
    
    //MARK: - UPDATE
    func update(){
        changechunks()
        partition()
    }
}
