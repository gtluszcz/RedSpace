//
//  File.swift
//  Space
//
//  Created by Henryk Tłuszcz on 30.07.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//


import SpriteKit
import Foundation

class Enemy: SKSpriteNode{
    //MARK: PROPERTIES
    var game: GameScene!
    
    //Movement management
    var aimRotation: CGFloat = 0
    var moveRotation: CGFloat = 0
    var thrusters: CGFloat = 0
    var rotatespeed: CGFloat = 0
    var shootingrange: CGFloat = 0
    
    //Health 
    var maxhealth: CGFloat!
    var currenthealth: CGFloat!

    
    // MARK: - INIT
    init(scene: GameScene){
        self.game = scene
        let texture = SKTexture()
        super.init(texture: texture, color: UIColor.clear,size: texture.size())
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    func setup(){
        zPosition = 0
    }
    
    func settexture(texturename: String, size: CGSize){
        let texture = SKTexture(imageNamed: texturename)
        self.texture = texture
        self.size = size
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
    
    func damage(damage: CGFloat){
        (currenthealth)!-=damage;
        if self.game.debug{
            indicatedamage(damage: damage)
        }
        if currenthealth < 0 {
            let point = CGPoint(x: self.position.x + (self.parent?.position.x)! , y: self.position.y + (self.parent?.position.y)!)
            disappear()
            self.game.collisions.makeexplosion(point: point, size: CGSize(width: 100, height: 100), percentage: 0)
            
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
        self.game.enemies.remove(at: self.game.enemies.index(of: self)!)
        self.removeFromParent()
    }
    
    func update(){
       changechunks()
    }
}
