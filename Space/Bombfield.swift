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
    var game: SKScene!
    var size: CGSize!
    var activated: Bool = false
    
    //MARK: - INIT
    override init() {
        super.init()
    }
    convenience init(scene: SKScene, position: CGPoint, maxradius: CGFloat, unit: CGFloat) {
        self.init()
        if maxradius*0.8 < (10 * unit){
            self.init(circleOfRadius: maxradius*0.8)
            self.size = CGSize(width: maxradius*0.8*2, height: maxradius*0.8*2)
        }
        else{
            self.init(circleOfRadius: 10 * unit)
            self.size = CGSize(width: 10 * unit * 2, height: 10 * unit*2)
        }
        self.game = scene
        setup(position: position, maxradius: maxradius, unit: unit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(position: CGPoint, maxradius: CGFloat, unit: CGFloat){
        self.name = "bombfield"
        self.position = position
        self.fillColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 0.2)
        self.strokeColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 0.04)
        self.zPosition = 0
        self.fillTexture = SKTexture(imageNamed: "danger")
        
        let mine = Mine(scene: self.game)
        self.addChild(mine)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bombfield
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.isDynamic = false
    }
    
    //MARK: - FUNCTIONALITY
    func activate(){
        self.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.fillColor = UIColor.clear
        self.strokeColor = SKColor.init(red: 1, green: 0, blue: 0, alpha: 0.4)
        self.lineWidth = 4
        self.activated = true
        print("activated")
    }
    
    func update(){
        if self.activated == true{
            print("working")
            self.activated = false
        }
        for child in self.children{
            let mine =  child as? Mine
            mine?.update()
        }
    }

    

}
