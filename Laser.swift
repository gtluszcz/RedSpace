//
//  Laser.swift
//  Space
//
//  Created by Henryk on 16.04.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//
import SpriteKit

class Laser: SKSpriteNode{
    
    //MARK: PROPERTIES
    var game: GameScene!
    var damage: CGFloat = 1
    var laserspeed: CGFloat = 800
    var laserlvl = 1
    var destroyed = false
    
    //MARK: - INIT
    
    init(scene: GameScene, laserlvl: Int, damage: CGFloat, speed: CGFloat, aimdirection: CGFloat, kind: Int=1){
        var texture = SKTexture(imageNamed: "laserRed03_orange")
        if kind == 1{
            texture = SKTexture(imageNamed: "laserRed03_orange")
        }
        else if kind == 2{
            texture = SKTexture(imageNamed: "laserRed03")
        }
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup(laserlvl: laserlvl, damage: damage, speed: speed, aimdirection: aimdirection)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(laserlvl: Int, damage: CGFloat, speed: CGFloat, aimdirection: CGFloat){
        //set properties
        self.zPosition = 1
        self.zRotation = aimdirection - CGFloat(Double.pi / 2)
        self.size = CGSize(width: 6, height: 24)
        self.damage = damage
        self.laserspeed = speed
        self.laserlvl = laserlvl
        
        //add to groups
        self.game.lasers.append(self)
        
        //set physics
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Planet | PhysicsCategory.Mine | PhysicsCategory.Enemy | PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.velocity = CGVector(dx: self.laserspeed * cos(aimdirection), dy: self.laserspeed * sin(aimdirection))
        
    }
    //MARK: - FUNCTIONALITY
    func disappear(){
        if abs(self.position.x - self.game.Player.position.x) > self.game.frame.width / 2 {
            //print("<|> destroyed")
            destroy()
            
        }
        else if abs(self.position.y - self.game.Player.position.y) > self.game.frame.height / 2{
            //print("<|> destroyed")
            destroy()
        }
        
    }
    func destroy(){
        self.game.lasers.remove(at: self.game.lasers.index(of: self)!)
        self.removeFromParent()
    }
    
    func managelevels(){
        switch self.laserlvl {
        case 1:
             self.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Planet | PhysicsCategory.Mine | PhysicsCategory.Enemy
        case 2:
             self.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Planet | PhysicsCategory.Mine | PhysicsCategory.Player | PhysicsCategory.Enemy
        default:
            print("Error wrong laserlvl")
        }
    }
    
    //MARK: - UPDATE
    func update(){
        managelevels()
        if !destroyed{disappear()}
        if destroyed{destroy()}
    }
}
