//
//  Bomb.swift
//  Space
//
//  Created by Henryk on 03.03.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
class Bombfield: SKShapeNode{
    //MARK: PROPERTIES
    
    
    //MARK: - INIT
    
    override init() {
        super.init()
    }
    convenience init(position: CGPoint, maxradius: CGFloat, unit: CGFloat) {
        self.init()
        if maxradius*0.8 < (10 * unit){
            self.init(circleOfRadius: maxradius*0.8)
        }
        else{
            self.init(circleOfRadius: 10 * unit)
        }
        setup(position: position, maxradius: maxradius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint, maxradius: CGFloat){
        self.position = position
        self.fillColor = UIColor.clear
        self.strokeColor = UIColor.red
        self.zPosition = 98
    }
    

}
