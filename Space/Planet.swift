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
    
    
    //MARK: - INIT
    
    override init() {
        super.init()
    }
    convenience init(radius: CGFloat, position: CGPoint, color: UIColor) {
        self.init()
        self.init(circleOfRadius: radius)
        setup(position: position, color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint, color: UIColor){
        self.position = position
        self.fillColor = color
        self.strokeColor = color
        self.zPosition = 98
    }
}
