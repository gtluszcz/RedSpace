//
//  Spaceship.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode{
    
    //MARK: PROPERTIES
    
    var currentRad: CGFloat = 0
    
    // MARK: - INIT
    
    init(){
        let texture = SKTexture(imageNamed: "statek ")
        super.init(texture: texture, color: UIColor.clear,size: texture.size())
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(){
        size = CGSize(width: 40, height: 40)

    }
    
    //MARK: - FUNCTIONALITY
    
    func moveToTouchLocation(touch: UITouch, scene: GameScene){
        let dx = touch.location(in: scene).x - touch.previousLocation(in: scene).x
        let dy = touch.location(in: scene).y - touch.previousLocation(in: scene).y

        self.position.y += dy
        self.position.x += dx
    
        let rad = atan2(dx, dy)
        
        if abs(rad - self.currentRad)>CGFloat(M_PI/12){
            let rotate = SKAction.rotate(toAngle: -rad, duration: 0.15, shortestUnitArc:true)
            self.run(rotate)
            self.currentRad = rad
        }
        
    }
}
