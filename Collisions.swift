//
//  Collisions.swift
//  Space
//
//  Created by Henryk on 18.04.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Collisions{
    var game: GameScene!
    
    init(game: GameScene){
        self.game = game
    }
    
    //Contact: Spaceship - Minefield
    func contactPlayerBombfield(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Minefield{
            let minefield = contact.bodyB.node as! Minefield
            let player = contact.bodyA.node as! Spaceship
            playerminefield(spaceship: player, minefield: minefield, contact: contact)

        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Minefield && contact.bodyB.categoryBitMask == PhysicsCategory.Player{
            let minefield = contact.bodyA.node as! Minefield
            let player = contact.bodyB.node as! Spaceship
            playerminefield(spaceship: player, minefield: minefield, contact: contact)
            
        }
    }
    
    //Contact: Spaceship - Mine
    func contactPlayerMine(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Mine{
            let mine = contact.bodyB.node as! Mine
            let player = contact.bodyA.node as! Spaceship
            playermine(spaceship: player, mine: mine, contact: contact)
            
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Mine && contact.bodyB.categoryBitMask == PhysicsCategory.Player{
            let mine = contact.bodyA.node as! Mine
            let player = contact.bodyB.node as! Spaceship
            playermine(spaceship: player, mine: mine, contact: contact)
        }
    }
    
    //Contact: Laser - Asteroid
    func contactLaserAsteroid(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Laser && contact.bodyB.categoryBitMask == PhysicsCategory.Asteroid{
            let asteroid = contact.bodyB.node as! Asteroid
            let laser = contact.bodyA.node as! Laser
            laserasteroid(laser: laser, asteroid: asteroid, contact: contact)
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Asteroid && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            let asteroid = contact.bodyA.node as! Asteroid
            let laser = contact.bodyB.node as! Laser
            laserasteroid(laser: laser, asteroid: asteroid, contact: contact)
        }
    }
    
    //Contact: Laser - Planet
    func contactLaserPlanet(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Laser && contact.bodyB.categoryBitMask == PhysicsCategory.Planet{
            let planet = contact.bodyB.node as! Planet
            let laser = contact.bodyA.node as! Laser
            laserplanet(laser: laser, planet: planet, contact: contact)
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Planet && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            let planet = contact.bodyA.node as! Planet
            let laser = contact.bodyB.node as! Laser
            laserplanet(laser: laser, planet: planet, contact: contact)
        }
    }
    
    //Contact: Laser - Mine
    func contactLaserMine(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Laser && contact.bodyB.categoryBitMask == PhysicsCategory.Mine{
            let mine = contact.bodyB.node as! Mine
            let laser = contact.bodyA.node as! Laser
            lasermine(laser: laser, mine: mine, contact: contact)
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Mine && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            let mine = contact.bodyA.node as! Mine
            let laser = contact.bodyB.node as! Laser
            lasermine(laser: laser, mine: mine, contact: contact)
        }
    }
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    
    //MARK: - Contact: Player - Minefield
    func playerminefield(spaceship: Spaceship, minefield: Minefield, contact: SKPhysicsContact){
        print(" <O> minefield approached")
        minefield.activate1()
        let mine = minefield.bomb!
        mine.activated = true
    }
    
    
    //MARK: - Contact: Player - Mine
    func playermine(spaceship: Spaceship, mine: Mine, contact: SKPhysicsContact){
        print("  <*> prepare for hit")
        mine.physicsBody?.categoryBitMask = PhysicsCategory.None
        mine.exploded = true
        mine.isHidden = true
        
        //Make explosion
        makeexplosion(point: contact.contactPoint, size: CGSize(width: 140, height: 140))
    }
    
    
    //MARK: - Contact: Laser - Asteroid
    func laserasteroid(laser: Laser, asteroid: Asteroid, contact: SKPhysicsContact){
        laser.destroyed = true
        laser.isHidden = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.None
        
        asteroid.damage(damage: laser.damage)
        
        print(" <|> hit asteroid")
        //Make puff
        makepuff(point: contact.contactPoint)
    }
    
    //MARK: - Contact: Laser - Planet
    func laserplanet(laser: Laser, planet: Planet, contact: SKPhysicsContact){
        laser.destroyed = true
        laser.isHidden = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.None
        print(" <|> hit planet")
        //Make puff
        makepuff(point: contact.contactPoint)
    }
    
    //MARK: - Contact: Laser - Mine
    func lasermine(laser: Laser, mine: Mine, contact: SKPhysicsContact){
        if mine.activated{
            print(" <|> hit mine in air")
        }
        else if !mine.activated{
            print(" <|> hit inactive mine")
            mine.minefield.activate2()
        }
        laser.destroyed = true
        laser.isHidden = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.None
        mine.exploded = true

        
        //Make explosion
        let point = CGPoint(x: mine.position.x + (mine.parent?.position.x)! , y: mine.position.y + (mine.parent?.position.y)!)
        makeexplosion(point: point, size: CGSize(width: 140, height: 140))
        
    }
    
    
    
    
    
    
    //MARK: - FUNCTIONALITIES
    func makepuff(point: CGPoint){
        let puff = SKEmitterNode(fileNamed: "Explode1")
        puff?.position = point
        puff?.zPosition = 2
        self.game.addChild(puff!)
        let disappear = SKAction.removeFromParent()
        let delay = SKAction.wait(forDuration: TimeInterval(1))
        let doStuff = SKAction.sequence([delay,disappear])
        puff?.run(doStuff)
    }
    
    func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return abs(sqrt(dx * dx + dy * dy));
    }
    
    func makeexplosion(point: CGPoint, size: CGSize){
        var texture = SKTexture(imageNamed: "explosion_f1")
        let explosion = SKSpriteNode(texture: texture, color: UIColor.clear, size: texture.size())
        self.game.addChild(explosion)
        explosion.size = size
        explosion.position = point
        explosion.zPosition = 2
        var textures = [SKTexture]()
        for i in 1..<13{
            texture = SKTexture(imageNamed: "explosion_f\(i)")
            textures.append(texture)
        }
        let changetexture = SKAction.animate(with: textures, timePerFrame: TimeInterval(0.04))
        let disappear = SKAction.removeFromParent()
        let doStuff = SKAction.sequence([changetexture, disappear])
        explosion.run(doStuff)
        
        let shield = SKFieldNode.springField()
        shield.position = point
        shield.strength = -0.08
        shield.categoryBitMask = PhysicsCategory.Explosion
        shield.region = SKRegion(radius: 100)
        shield.falloff = 1
        shield.run(SKAction.sequence([
            SKAction.strength(to: 0, duration: 0.1),
            SKAction.removeFromParent()
            ]))
        self.game.addChild(shield)
        
        
        /// hurt asteroids in explosion
        for asteroid in self.game.asteroids {
            let dist = distance(point1: point, point2: asteroid.position)
            if dist < 300{
                print(dist)
                asteroid.damage(damage: 10000/dist)
            }
        }
        
        
        /// hurt player in explosion
        let dist = distance(point1: point, point2: self.game.Player.position)
        if dist < 100{
            self.game.Player.damage(damage: 3000/dist)
           
        }
        
    }
}
