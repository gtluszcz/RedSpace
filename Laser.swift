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
    var flightspeed: CGFloat = 800
    var destroyed = false
    
    //MARK: - INIT
    
    init(scene: GameScene, laserlvl: Int, aimdirection: CGFloat){
        let texture = SKTexture(imageNamed: "laserRed03")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup(laserlvl: laserlvl, aimdirection: aimdirection)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(laserlvl: Int, aimdirection: CGFloat){
        //set properties
        self.zPosition = 1
        self.zRotation = aimdirection - CGFloat(Double.pi / 2)
        self.size = CGSize(width: 6, height: 24)
        
        //add to groups
        self.game.lasers.append(self)
        
        //set physics
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Planet | PhysicsCategory.Mine
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.velocity = CGVector(dx: self.flightspeed * cos(aimdirection), dy: self.flightspeed * sin(aimdirection))
        
    }
    //MARK: - FUNCTIONALITY
    func disappear(){
        if abs(self.position.x - self.game.Player.position.x) > self.game.frame.width / 2 {
            print("<laser> destroyed")
            destroy()
            
        }
        else if abs(self.position.y - self.game.Player.position.y) > self.game.frame.height / 2{
            print("<laser> destroyed")
            destroy()
        }
        
    }
    func destroy(){
        self.game.lasers.remove(at: self.game.lasers.index(of: self)!)
        self.removeFromParent()
    }
    
    //MARK: - UPDATE
    func update(){
        if !destroyed{disappear()}
        if destroyed{destroy()}
    }
}
