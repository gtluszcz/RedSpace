//
//  Bomb.swift
//  Space
//
//  Created by Henryk on 03.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import GameplayKit
class Bombfield: SKShapeNode{
    //MARK: PROPERTIES
    var size: CGSize!
    
    //MARK: - INIT
    override init() {
        super.init()
    }
    convenience init(position: CGPoint, maxradius: CGFloat, unit: CGFloat) {
        self.init()
        if maxradius*0.8 < (10 * unit){
            self.init(circleOfRadius: maxradius*0.8)
            self.size = CGSize(width: maxradius*0.8*2, height: maxradius*0.8*2)
        }
        else{
            self.init(circleOfRadius: 10 * unit)
            self.size = CGSize(width: 10 * unit * 2, height: 10 * unit*2)
        }
        setup(position: position, maxradius: maxradius, unit: unit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint, maxradius: CGFloat, unit: CGFloat){
        self.position = position
        self.fillColor = SKColor.white
        self.strokeColor = UIColor.clear
        self.zPosition = 0
        self.fillTexture = SKTexture(imageNamed: "danger")
        
        let mine = Mine()
        self.addChild(mine)
        
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
    }
    

}
