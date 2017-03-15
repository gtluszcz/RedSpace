//
//  Mine.swift
//  Space
//
//  Created by Henryk on 04.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit

class Mine: SKSpriteNode{
    
    //MARK: PROPERTIES
    var game: SKScene!
    
    //MARK: - INIT
    
    init(scene: SKScene){
        let texture = SKTexture(imageNamed: "spaceParts_043")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(){
        size = CGSize(width: 10, height: 25)
        self.name = "mine"
        
    }
    
    func update(){
    }
}
