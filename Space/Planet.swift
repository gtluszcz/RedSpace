//
//  Planet.swift
//  Space
//
//  Created by Henryk on 27.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit

class Planet: SKShapeNode{
    
    //MARK: PROPERTIES
    var game: SKScene!
    
    //MARK: - INIT
    
    override init() {
        super.init()
    }
    convenience init(scene: SKScene, radius: CGFloat, position: CGPoint, color: UIColor, unit: CGFloat) {
        self.init()
        if radius < (30 * unit){
            self.init(circleOfRadius: radius)
        }
        else{
            self.init(circleOfRadius: 30 * unit)
        }
        self.game = scene
        setup(position: position, color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint, color: UIColor){
        self.position = position
        self.fillColor = SKColor.white
        self.strokeColor = UIColor.clear
        self.zPosition = 10
        self.fillTexture = SKTexture(imageNamed: "planet1")
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width / 2)
        physicsBody!.categoryBitMask = PhysicsCategory.Planet
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        self.physicsBody?.isDynamic = false
        
    
    }
    
    func update(){
    }
}
