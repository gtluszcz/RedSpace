//
//  Spaceship.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import Foundation

class Spaceship: SKSpriteNode{
    //MARK: PROPERTIES
    
    var currentRad: CGFloat = 0
    
    // MARK: - INIT
    
    init(){
        let texture = SKTexture(imageNamed: "statek")
        super.init(texture: texture, color: UIColor.clear,size: texture.size())
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(){
        size = CGSize(width: 40, height: 40)
        speed = 5

    }
    
    //MARK: - FUNCTIONALITY
    
    
    func moveToTouchLocation(touch: UITouch, joystick: SKShapeNode, joysticktwo: SKShapeNode? = nil){
        let joystickpad = (joystick.childNode(withName: "pad"))!
        
        //calculate distance form joystick center to touch location
        let jsdist = (touch.location(in: joystick).x)*(touch.location(in: joystick).x) + (touch.location(in: joystick).y)*(touch.location(in: joystick).y)
        
        
        let dx = touch.location(in: joystick).x
        let dy = touch.location(in: joystick).y
        let rad = atan2(dy, dx)
        
        //move Player
        self.position.x += speed*cos(rad)
        self.position.y += speed*sin(rad)
        
        //move Joysticks
        joystick.position.x += speed*cos(rad)
        joystick.position.y += speed*sin(rad)
        if joysticktwo != nil{
            joysticktwo?.position.x += speed*cos(rad)
            joysticktwo?.position.y += speed*sin(rad)
        }
        
        // Move joystick pads inside joysticks
        if jsdist <= 900{
            let point = CGPoint(x: cos(rad)*sqrt(jsdist), y: sin(rad)*sqrt(jsdist))
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
        }
        else if jsdist > 900{
            let point = CGPoint(x: cos(rad)*20, y: sin(rad)*20)
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
        
        }
    
    }
    func roatetotouch(touch: UITouch, joystick: SKShapeNode){
        let joystickpad = (joystick.childNode(withName: "pad"))!
        //calculate distance form joystick center to touch location
        let jsdist = (touch.location(in: joystick).x)*(touch.location(in: joystick).x) + (touch.location(in: joystick).y)*(touch.location(in: joystick).y)
        
        
        let dx = touch.location(in: joystick).x
        let dy = touch.location(in: joystick).y
        let rad = atan2(dy, dx)
        
        let rotate = SKAction.rotate(toAngle: rad - CGFloat(M_PI / 2), duration: 0.15, shortestUnitArc:true)
        self.run(rotate)
        
        // Move joystick pads inside joysticks
        if jsdist <= 900{
            let point = CGPoint(x: cos(rad)*sqrt(jsdist), y: sin(rad)*sqrt(jsdist))
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
        }
        else if jsdist > 900{
            let point = CGPoint(x: cos(rad)*20, y: sin(rad)*20)
            let action = SKAction.move(to: point, duration: 0.02)
            joystickpad.run(action)
            
        }
    }
    
}

















