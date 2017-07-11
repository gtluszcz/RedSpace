//
//  Spaceship.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import Foundation

class Spaceship: SKSpriteNode{ 
    //MARK: PROPERTIES
    var game: GameScene!
    var dim: CGFloat!
    
    //Movement management
    var aimRotation: CGFloat = 0
    var moveRotation: CGFloat = 0
    var thrusters: CGFloat = 20
    var swiftiness: CGFloat = 1.5
    
    //Shooting management
    var laserlvl = 1
    var lasttimeshoot = NSDate()
    var shootingrarity = 0.15
    var lastshootingcannon = 1
    var laserspeed: CGFloat = 800
    var laserdamage: CGFloat = 5
    
    //Durability management
    var maxhealth: CGFloat = 300
    var maxshieldhealth: CGFloat = 300
    var health: CGFloat = 300
    var shieldhealth: CGFloat = 300
    var shield: SKSpriteNode!
    
    // MARK: - INIT
    
    init(scene: GameScene, size: CGSize){
        let texture = SKTexture(imageNamed: "statek")
        super.init(texture: texture, color: UIColor.clear,size: texture.size())
        self.game = scene
        self.dim = max(size.width, size.height) / 100
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(){
        self.name = "player"
        self.zPosition=0
        size = CGSize(width: 40, height: 40)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.Planet | PhysicsCategory.Asteroid
        physicsBody!.contactTestBitMask = PhysicsCategory.Minefield | PhysicsCategory.Mine
        self.physicsBody?.fieldBitMask = PhysicsCategory.Explosion
        self.physicsBody?.linearDamping = self.swiftiness
        
        //setup shield
        let texture = SKTexture(imageNamed: "shield2")
        let shieldsize = CGSize(width: 65, height: 65)
        shield = SKSpriteNode(texture: texture, color: UIColor.clear, size: shieldsize)
        self.addChild(shield)
        

    }
    
    //MARK: - FUNCTIONALITY
    
    
    func moveToTouchLocation(touch: UITouch, joystick: SKShapeNode, joysticktwo: SKShapeNode? = nil){
        let joystickpad = (joystick.childNode(withName: "pad"))!
        
        //calculate distance form joystick center to touch location
        let jsdist = (touch.location(in: joystick).x)*(touch.location(in: joystick).x) + (touch.location(in: joystick).y)*(touch.location(in: joystick).y)
        
        
        let dx = touch.location(in: joystick).x
        let dy = touch.location(in: joystick).y
        let rad = atan2(dy, dx)
        
        //move Player
        self.moveRotation = rad
        move()
        
        
        // Move joystick pads inside joysticks
        if jsdist <= 900{
            let point = CGPoint(x: cos(rad)*sqrt(jsdist), y: sin(rad)*sqrt(jsdist))
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
        }
        else if jsdist > 900{
            let point = CGPoint(x: cos(rad)*20, y: sin(rad)*20)
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
        
        }
    
    }
    func roatetotouch(touch: UITouch, joystick: SKShapeNode){
        let joystickpad = (joystick.childNode(withName: "pad"))!
        //calculate distance form joystick center to touch location
        let jsdist = (touch.location(in: joystick).x)*(touch.location(in: joystick).x) + (touch.location(in: joystick).y)*(touch.location(in: joystick).y)
        
        
        let dx = touch.location(in: joystick).x
        let dy = touch.location(in: joystick).y
        let rad = atan2(dy, dx)
        
        
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.angularVelocity = 0
        if jsdist >= 10{
        self.aimRotation = rad
        let rotate = SKAction.rotate(toAngle: rad - CGFloat(Double.pi / 2), duration: 0.1, shortestUnitArc:true)
        self.run(rotate)
      
        }
        
        // Move joystick pads inside joysticks
        if jsdist <= 900{
            let point = CGPoint(x: cos(rad)*sqrt(jsdist), y: sin(rad)*sqrt(jsdist))
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
        }
        else if jsdist > 900{
            let point = CGPoint(x: cos(rad)*20, y: sin(rad)*20)
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
            
        }
    }
    func move(){
        self.physicsBody?.applyForce(CGVector(dx: self.thrusters * cos(self.moveRotation), dy: self.thrusters * sin(self.moveRotation)))        
    }
    func enginesoff(){
        self.physicsBody?.allowsRotation = true

    }
    func shootlasers(){
        if lasttimeshoot.timeIntervalSinceNow < -shootingrarity {
            lasttimeshoot = NSDate()
            switch self.laserlvl {
            case 1:
                let laser = Laser(scene: self.game, laserlvl: self.laserlvl, damage: self.laserdamage ,speed: self.laserspeed, aimdirection: self.aimRotation)
                self.game.addChild(laser)
                let kat = atan2(11.0, 20)
                if lastshootingcannon == 1{
                    lastshootingcannon = 2
                    laser.position.x = self.position.x + 25 * cos(aimRotation + CGFloat(kat))
                    laser.position.y = self.position.y + 25 * sin(aimRotation + CGFloat(kat))
                }
                else if lastshootingcannon == 2{
                    lastshootingcannon = 1
                    laser.position.x = self.position.x + 25 * cos(aimRotation - CGFloat(kat))
                    laser.position.y = self.position.y + 25 * sin(aimRotation - CGFloat(kat))
                }
            default:
                print("wrong Spaceship.laserlevel")
            }
        }
    }
    func manageshields(){
        if shieldhealth >= 300 {
            shield.texture = SKTexture(imageNamed: "shield3")
            shield.size = CGSize(width: 65, height: 65)
        }
        else if shieldhealth >= 160{
            shield.texture = SKTexture(imageNamed: "shield2")
            shield.size = CGSize(width: 60, height: 50)
            shield.position.y = 5
        }
        else if shieldhealth >= 80 {
            shield.texture = SKTexture(imageNamed: "shield1")
            shield.size = CGSize(width: 60, height: 50)
            shield.position.y =  5

        }
        else if shieldhealth >= 0{
            shield.isHidden = true
        }
    }
    
    func damage(damage: CGFloat){
        if shieldhealth >= damage{
            shieldhealth -= damage
        }
        else if shieldhealth < damage{
            var dmg = damage
            dmg -= shieldhealth
            shieldhealth = 0
            health -= dmg
        }
    }
    
    func update(){
        manageshields()
    }
}

















