//
//  Joystick.swift
//  Space
//
//  Created by Henryk on 09.04.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation
import SpriteKit

class Joystick: SKShapeNode{
    //MARK: PROPERTIES
    var game: GameScene!
    
    //MARK: - INIT
    
    override init() {
        super.init()
    }
    convenience init(scene: GameScene, radius: CGFloat, position: CGPoint) {
        self.init()
        self.init(circleOfRadius: radius)
        self.game = scene
        setup(position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint){
        self.position = position
        self.strokeColor = UIColor.white
        self.lineWidth = 4
        self.zPosition = 99
        
        let joystickpad = SKShapeNode(circleOfRadius: 25)
        joystickpad.fillColor = UIColor.white
        joystickpad.name = "pad"
        joystickpad.zPosition = 99
        self.addChild(joystickpad)
        
    }
    
    func update(){
    }
}
