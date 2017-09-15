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
    
    //Contact: Laser - Player
    func contactLaserPlayer(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Laser && contact.bodyB.categoryBitMask == PhysicsCategory.Player{
            let player = contact.bodyB.node as! Spaceship
            let laser = contact.bodyA.node as! Laser
            laserplayer(laser: laser, player: player, contact: contact)
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            let player = contact.bodyA.node as! Spaceship
            let laser = contact.bodyB.node as! Laser
            laserplayer(laser: laser, player: player, contact: contact)
        }
    }
    
    //Contact: Laser - Enemy
    func contactLaserEnemy(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Laser && contact.bodyB.categoryBitMask == PhysicsCategory.Enemy{
            let enemy = contact.bodyB.node as! Enemy
            let laser = contact.bodyA.node as! Laser
            laserenemy(laser: laser, enemy: enemy, contact: contact)        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Enemy && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            let enemy = contact.bodyA.node as! Enemy
            let laser = contact.bodyB.node as! Laser
            laserenemy(laser: laser, enemy: enemy, contact: contact)
        }
    }
    
    //Contact: Mine - Enemy
    func contactMineEnemy(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Mine && contact.bodyB.categoryBitMask == PhysicsCategory.Enemy{
            let enemy = contact.bodyB.node as! Enemy
            let mine = contact.bodyA.node as! Mine
            mineenemy(mine: mine, enemy: enemy, contact: contact)        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Enemy && contact.bodyB.categoryBitMask == PhysicsCategory.Mine{
            let enemy = contact.bodyA.node as! Enemy
            let mine = contact.bodyB.node as! Mine
            mineenemy(mine: mine, enemy: enemy, contact: contact)
        }
    }
    
    //Contact: Mine - Asteroid
    func contactMineAsteroid(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Mine && contact.bodyB.categoryBitMask == PhysicsCategory.Asteroid{
            let asteroid = contact.bodyB.node as! Asteroid
            let mine = contact.bodyA.node as! Mine
            mineasteroid(mine: mine, asteroid: asteroid, contact: contact)
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Asteroid && contact.bodyB.categoryBitMask == PhysicsCategory.Mine{
            let asteroid = contact.bodyA.node as! Asteroid
            let mine = contact.bodyB.node as! Mine
            mineasteroid(mine: mine, asteroid: asteroid, contact: contact)
        }
    }
    
    //Contact: Mine - Planet
    func contactMinePlanet(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Mine && contact.bodyB.categoryBitMask == PhysicsCategory.Planet{
            let planet = contact.bodyB.node as! Planet
            let mine = contact.bodyA.node as! Mine
            mineplanet(mine: mine, planet: planet, contact: contact)
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Planet && contact.bodyB.categoryBitMask == PhysicsCategory.Mine{
            let planet = contact.bodyA.node as! Planet
            let mine = contact.bodyB.node as! Mine
            mineplanet(mine: mine, planet: planet, contact: contact)
        }
    }
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    
    //MARK: - Contact: Player - Minefield
    func playerminefield(spaceship: Spaceship, minefield: Minefield, contact: SKPhysicsContact){
        print(" <O> minefield approached")
        minefield.activate1()
        let mine = minefield.bomb!
        mine.activated = true
        
        let chunk = minefield.parent as! Chunk
        let dx = (mine.position.x + chunk.gridPos.x*chunk.size.width) - spaceship.position.x
        let dy = (mine.position.y + chunk.gridPos.y*chunk.size.height) - spaceship.position.y
        let rad = atan2(dy, dx)
        let rotate = SKAction.rotate(toAngle: rad + CGFloat(Double.pi * 1.5), duration: 0, shortestUnitArc: true)
        mine.run(rotate)

    }
    
    
    //MARK: - Contact: Player - Mine
    func playermine(spaceship: Spaceship, mine: Mine, contact: SKPhysicsContact){
        print("  <*> prepare for hit")
        mine.physicsBody?.categoryBitMask = PhysicsCategory.None
        mine.exploded = true
        mine.isHidden = true
        
        //Make explosion
        makeexplosion(point: contact.contactPoint, size: CGSize(width: 140, height: 140), percentage: 1)
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
        makeexplosion(point: point, size: CGSize(width: 140, height: 140), percentage: 1)
        
    }
    
    //MARK: - Contact: Laser - Player
    func laserplayer(laser: Laser, player: Spaceship, contact: SKPhysicsContact){
        laser.destroyed = true
        laser.isHidden = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.None
        player.damage(damage: laser.damage)
        makespark(point: contact.contactPoint)
      
    }
    
    //MARK: - Contact: Laser - Enemy
    func laserenemy(laser: Laser, enemy: Enemy, contact: SKPhysicsContact){
        laser.destroyed = true
        laser.isHidden = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.None
        enemy.damage(damage: laser.damage)
        makespark(point: contact.contactPoint)
        
        
    }
    
    //MARK: - Contact: Mine - Enemy
    func mineenemy(mine: Mine, enemy: Enemy, contact: SKPhysicsContact){
        if mine.activated{
            print(" <|> enemy hit mine in air")
            mine.exploded = true
            //Make explosion
            //let point = CGPoint(x: mine.position.x + (mine.parent?.position.x)! , y: mine.position.y + (mine.parent?.position.y)!)
            let point = contact.contactPoint
            makeexplosion(point: point, size: CGSize(width: 140, height: 140), percentage: 1)
        }
    }
    
    //MARK: - Contact: Mine - Asteroid
    func mineasteroid(mine: Mine, asteroid: Asteroid, contact: SKPhysicsContact){
        if mine.activated{
            print(" <|> asteroid hit mine in air")
            mine.exploded = true
            //Make explosion
            //let point = CGPoint(x: mine.position.x + (mine.parent?.position.x)! , y: mine.position.y + (mine.parent?.position.y)!)
            let point = contact.contactPoint
            makeexplosion(point: point, size: CGSize(width: 140, height: 140), percentage: 1.3)
        }
    }
    
    //MARK: - Contact: Mine - Asteroid
    func mineplanet(mine: Mine, planet: Planet, contact: SKPhysicsContact){
        if mine.activated{
            print(" <|> mine hit planet in air")
            mine.exploded = true
            //Make explosion
            //let point = CGPoint(x: mine.position.x + (mine.parent?.position.x)! , y: mine.position.y + (mine.parent?.position.y)!)
            let point = contact.contactPoint
            makeexplosion(point: point, size: CGSize(width: 140, height: 140), percentage: 1)
        }
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
    
    func makespark(point: CGPoint){
        let puff = SKEmitterNode(fileNamed: "Spark")
        puff?.position = point
        puff?.zPosition = 2
        puff?.setScale(0.25)
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
    
    func makeexplosion(point: CGPoint, size: CGSize, percentage: CGFloat){
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
            let pos = CGPoint(x: asteroid.position.x + (asteroid.parent?.position.x)!, y: asteroid.position.y + (asteroid.parent?.position.y)!)
            let dist = distance(point1: point, point2: pos)
            if dist < 100{
                asteroid.damage(damage: percentage * 10000 / dist)
            }
        }
        
        /// hurt enemies in explosion
        for enemy in self.game.enemies {
            let pos = CGPoint(x: enemy.position.x + (enemy.parent?.position.x)!, y: enemy.position.y + (enemy.parent?.position.y)!)
            let dist = distance(point1: point, point2: pos)
            if dist < 100{
                enemy.damage(damage: percentage * 7000 / dist)
            }
        }
        
        
        /// hurt player in explosion
        let dist = distance(point1: point, point2: self.game.Player.position)
        if dist < 100{
            self.game.Player.damage(damage: percentage * 7000 / dist)
           
        }
        
    }
}
