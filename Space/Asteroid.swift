//
//  normalAsteroid.swift
//  Space
//
//  Created by Henryk on 21.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation
import SpriteKit

class Asteroid: SKSpriteNode{
    
    //MARK: PROPERTIES
    var game: GameScene!
    
    //MARK: - INIT
    init(scene: GameScene, kind: Int, size: CGFloat, position: CGPoint){
        let texture = SKTexture(imageNamed: "Meteor\(kind)v4")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup(size: size, position: position)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(size: CGFloat, position: CGPoint){
        //set properties
        self.position = position
        self.zPosition = 1
        
        //append to groups
        self.game.asteroids.append(self)
        
        
        //define physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: max(self.size.width,self.size.height) / 2 * 0.9)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Player | PhysicsCategory.Planet
        self.physicsBody?.isResting = true
        
    }
    //MARK: - FUNCTIONALITY
    func changechunks(){
        if self.physicsBody?.velocity != CGVector(dx: 0, dy: 0){
            let oldvelocity = self.physicsBody?.velocity
            let oldangularvelocity = self.physicsBody?.angularVelocity
            let oldchunk = self.parent as! Chunk
            if self.position.x >= oldchunk.size.width / 2{
                for chunk in self.game.chunks{
                    if chunk.intersects(self) && chunk.position.y == oldchunk.position.y && chunk != oldchunk && chunk.position.x > oldchunk.position.x{
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.x = (oldchunk.size.width / -2) + self.position.x - oldchunk.size.width / 2

                        
                    }
                }
                
            }
            else if self.position.x <= oldchunk.size.width / -2{
                for chunk in self.game.chunks{
                    if  chunk.intersects(self) && chunk.position.y == oldchunk.position.y && chunk != oldchunk && chunk.position.x < oldchunk.position.x{
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.x = (oldchunk.size.width / 2) + self.position.x - oldchunk.size.width / -2
                    }
                }
                
            }
            if self.position.y >= oldchunk.size.height / 2{
                for chunk in self.game.chunks{
                    if chunk.intersects(self) && chunk.position.x == oldchunk.position.x && chunk != oldchunk && chunk.position.y > oldchunk.position.y{
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.y = (oldchunk.size.height / -2) + self.position.y - oldchunk.size.height / 2
                        
                    }
                }
            }
            else if self.position.y <= oldchunk.size.height / -2{
                for chunk in self.game.chunks{
                    if chunk.intersects(self) && chunk.position.x == oldchunk.position.x && chunk != oldchunk && chunk.position.y < oldchunk.position.y{
                        self.removeFromParent()
                        chunk.addChild(self)
                        self.physicsBody?.velocity = oldvelocity!
                        self.physicsBody?.angularVelocity = oldangularvelocity!
                        self.position.y = (oldchunk.size.height / 2) + self.position.y - oldchunk.size.height / -2


                    }
                }
            }
        }
    }
    
    //MARK: - UPDATE
    func update(){
       changechunks()
    }
}
