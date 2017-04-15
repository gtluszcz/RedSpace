//
//  Bomb.swift
//  Space
//
//  Created by Henryk on 03.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import GameplayKit
class Minefield: SKShapeNode{
    //MARK: PROPERTIES
    var game: GameScene!
    var size: CGSize!
    var activated: Bool = false
    var bomb: Mine!
    
    //MARK: - INIT
    override init() {
        super.init()
    }
    convenience init(scene: GameScene, position: CGPoint, maxradius: CGFloat, unit: CGFloat) {
        self.init()
        if maxradius < (14 * unit){
            self.init(circleOfRadius: maxradius)
            self.size = CGSize(width: maxradius*2, height: maxradius*2)
        }
        else{
            self.init(circleOfRadius: 12 * unit)
            self.size = CGSize(width: 12 * unit * 2, height: 12 * unit*2)
        }
        self.game = scene
        setup(position: position, maxradius: maxradius, unit: unit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint, maxradius: CGFloat, unit: CGFloat){
        //set properties
        self.name = "bombfield"
        self.position = position
        self.fillColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 0.2)
        self.strokeColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 0.04)
        self.zPosition = 0
        self.fillTexture = SKTexture(imageNamed: "danger")
        
        //add to groups
        self.game.minefields.append(self)
        
        //set physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Minefield
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.isDynamic = false
    }
    
    //MARK: - FUNCTIONALITY
    func activate(){
        self.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.fillColor = UIColor.clear
        self.strokeColor = SKColor.init(red: 1, green: 0, blue: 0, alpha: 0.4)
        self.lineWidth = 4
        let action3 = SKAction.scale(to: 0.3, duration: 3)
        let action2 = SKAction.fadeOut(withDuration: 0.3)
        let group = SKAction.group([action3, action2])
        self.run(group)
        self.activated = true
        print(" <*> mine activated")
    }
    
    //MARK: - UPDATE
    func update(){
        if self.activated == true{
            print(" <*> homing missle launched")
            self.activated = false
        }
    }

    

}
