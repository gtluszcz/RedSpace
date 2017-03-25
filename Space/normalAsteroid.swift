//
//  normalAsteroid.swift
//  Space
//
//  Created by Henryk on 21.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation
import SpriteKit

class NormalAsteroid: SKSpriteNode{
    
    //MARK: PROPERTIES
    var game: SKScene!
    
    //MARK: - INIT
    
    init(scene: SKScene, kind: Int, size: CGFloat, position: CGPoint){
        let texture = SKTexture(imageNamed: "Meteor\(kind)")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup(size: size, position: position)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(size: CGFloat, position: CGPoint){
        self.position = position
        
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.NormalAsteroid
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.NormalAsteroid | PhysicsCategory.Player | PhysicsCategory.Planet
        
    }
    //MARK: - FUNCTIONALITY
    
    
    //MARK: - UPDATE
    func update(){
        
    }
}
