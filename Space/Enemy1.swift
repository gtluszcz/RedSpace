//
//  Enemy1.swift
//  Space
//
//  Created by Henryk Tłuszcz on 30.07.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//
import Foundation

import SpriteKit
import Foundation

class Enemy1: Enemy{
    //MARK: PROPERTIES
    
    
    //damage
    var aimray: SKSpriteNode!
    var damage: CGFloat = 5
    var lasttimeshoot = NSDate()
    var shootingrarity = 0.25
    var laserspeed: CGFloat = 800
    

    
    //autopilot
    var baserotation: CGFloat = 0
    var leftband: SKShapeNode!
    var rightband: SKShapeNode!
    var rotationbase: SKNode!
    
    
    // MARK: - INIT
    override init(scene: GameScene){
        super.init(scene: scene)
        self.game.enemies.append(self)
        setup2()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    func setup2(){
        // set texture
        settexture(texturename: "ship (1)", size: CGSize(width: 50, height: 50))
        
        
        // set physics
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        physicsBody!.collisionBitMask = PhysicsCategory.Planet | PhysicsCategory.Asteroid | PhysicsCategory.Enemy | PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Laser | PhysicsCategory.Mine
        self.physicsBody?.fieldBitMask = PhysicsCategory.Explosion
        self.physicsBody?.linearDamping = 2.0
        
        //set properties
        thrusters = 4000
        rotatespeed = 0.2
        shootingrange = 200
        physicsBody?.mass = 10
        maxhealth = 100
        currenthealth = maxhealth
        
        
        //set pathfinding bands
        leftband = SKShapeNode(rectOf: CGSize(width: 1, height: 50))
        rightband = SKShapeNode(rectOf: CGSize(width: 1, height: 50))
        rotationbase = SKNode()
        self.addChild(rotationbase)
        rotationbase.addChild(leftband)
        rotationbase.addChild(rightband)
        leftband.position.x = self.position.x - self.size.width / 2 + 5
        rightband.position.x = self.position.x + self.size.width / 2 - 5
        leftband.position.y = self.position.y + 50
        rightband.position.y = self.position.y + 50
        if self.game.debug{
            leftband.fillColor = UIColor.orange
            rightband.fillColor = UIColor.orange
            leftband.strokeColor = UIColor.orange
            rightband.strokeColor = UIColor.orange
        }
        else{
            leftband.fillColor = UIColor.clear
            rightband.fillColor = UIColor.clear
            leftband.strokeColor = UIColor.clear
            rightband.strokeColor = UIColor.clear
        }
        leftband.zRotation = CGFloat(Double.pi / -30)
        rightband.zRotation = CGFloat(Double.pi / 30)
        
        
        //set aiming path
        if self.game.debug{
            aimray = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 10, height: shootingrange))
        }
        else{
            aimray = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 10, height: shootingrange))

        }
        self.addChild(aimray)
        aimray.position.y += shootingrange / 2 + self.size.height / 2 + 5
       
        
        
        
        
        
    }
    
    func move(force: CGFloat, angle: CGFloat){
        self.physicsBody?.applyForce(CGVector(dx: force * cos(angle), dy: force * sin(angle)))
    }
    
    func rotateBaseToPlayer(){
        let game = self.game
        let chunk = self.parent as! Chunk
        let dx = (self.position.x + chunk.gridPos.x*chunk.size.width) - game!.Player.position.x
        let dy = (self.position.y + chunk.gridPos.y*chunk.size.height) - game!.Player.position.y
        let rad = atan2(dy, dx)
        self.baserotation = rad + CGFloat(Double.pi / 2)
        rotationbase.zRotation = -self.zRotation + baserotation
       

    }
    
    
    
    func autopilot(){
    rotateBaseToPlayer()
    moveRotation = baserotation
    //check for intersection
   
    var aimrotation = baserotation
        for planet in self.game.planets{
            if leftband.intersects(planet){
                
                let chunk1 = self.parent as! Chunk
                let chunk2 = planet.parent as! Chunk
                let dx = (self.position.x + chunk1.gridPos.x*chunk1.size.width) - (planet.position.x + chunk2.gridPos.x*chunk2.size.width)
                let dy = (self.position.y + chunk1.gridPos.y*chunk1.size.height) - (planet.position.y + chunk2.gridPos.y*chunk2.size.height)
                let rad = atan2(dy, dx)
                self.baserotation = rad
                aimrotation = baserotation + CGFloat(Double.pi / 4)
                moveRotation = baserotation + CGFloat(Double.pi / 12)
                rotationbase.zRotation = -self.zRotation + baserotation
                

            }
            else if rightband.intersects(planet){
                
                let chunk1 = self.parent as! Chunk
                let chunk2 = planet.parent as! Chunk
                let dx = (self.position.x + chunk1.gridPos.x*chunk1.size.width) - (planet.position.x + chunk2.gridPos.x*chunk2.size.width)
                let dy = (self.position.y + chunk1.gridPos.y*chunk1.size.height) - (planet.position.y + chunk2.gridPos.y*chunk2.size.height)
                let rad = atan2(dy, dx)
                self.baserotation = rad + CGFloat(Double.pi)
                aimrotation = baserotation - CGFloat(Double.pi / 4)
                moveRotation = baserotation - CGFloat(Double.pi / 12)
                rotationbase.zRotation = -self.zRotation + baserotation
               
            }
        }
        move(force: thrusters, angle: moveRotation + CGFloat(Double.pi / 2))
            
        
        let rotate = SKAction.rotate(toAngle: aimrotation , duration: 0.15, shortestUnitArc: true)
        self.run(rotate)
        
        

    }
    func updateaimraylength(){
        let game = self.game
        let chunk = self.parent as! Chunk
        let dx = (self.position.x + chunk.gridPos.x*chunk.size.width) - game!.Player.position.x
        let dy = (self.position.y + chunk.gridPos.y*chunk.size.height) - game!.Player.position.y
        var dist = sqrt(dx*dx + dy*dy)
        dist-=20
        if dist < shootingrange{
            let scale = SKAction.resize(toHeight: dist, duration: 0)
            aimray.position.y = dist / 2 + self.size.height / 2 + 5
            aimray.run(scale)
        }
        else{
            let scale = SKAction.resize(toHeight: shootingrange, duration: 0)
            aimray.position.y = shootingrange / 2 + self.size.height / 2 + 5
            aimray.run(scale)
        }
    
    }
    
    func shoot(){
        var canshoot = false
        var intersectsasteroid = false
        var intersectsplanet = false
        var intersectsenemy = false
        
        for planet in self.game.planets{
            if aimray.intersects(planet){
                intersectsplanet = true
            }
        }
        
        for enemy in self.game.enemies{
            if aimray.intersects(enemy){
                intersectsenemy = true
            }
        }
        
        for asteroid in self.game.asteroids{
            if aimray.intersects(asteroid){
                intersectsasteroid = true
            }
        }
        
        if lasttimeshoot.timeIntervalSinceNow < -shootingrarity && intersectsasteroid && !intersectsenemy{
            canshoot = true
        }
        
        if lasttimeshoot.timeIntervalSinceNow < -shootingrarity && !intersectsplanet && aimray.intersects(self.game.Player) && !intersectsenemy{
            canshoot = true
        }
        
        if canshoot{
            lasttimeshoot = NSDate()
            let laser = Laser(scene: self.game, laserlvl: 2, damage: self.damage ,speed: self.laserspeed, aimdirection: self.zRotation + CGFloat(Double.pi / 2))
            self.game.addChild(laser)
            let chunk = self.parent as! Chunk
            laser.position.x = self.position.x + chunk.gridPos.x*chunk.size.width + 40 * cos(zRotation + CGFloat(Double.pi / 2))
            laser.position.y = self.position.y + chunk.gridPos.y*chunk.size.height + 40 * sin(zRotation + CGFloat(Double.pi / 2))
        
        }
        

    }

    //MARK: - FUNCTIONALITY
    override func update(){
        updateaimraylength()
        autopilot()
        shoot()
        
        super.update()
        
        
    }
}
