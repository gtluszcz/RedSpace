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
    var game: GameScene!
    var activated = false
    var minefield: Minefield!
    var acceleration: CGFloat = 1
    var spped = 0
    var exhaust = SKEmitterNode(fileNamed: "mineExhaust")
    var exhaustshown = false
    var exploded = false
    
    //MARK: - INIT
    
    init(scene: GameScene, minefield: Minefield){
        let texture = SKTexture(imageNamed: "spaceParts_043")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.game = scene
        setup(minefield: minefield)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(minefield: Minefield){
        //set properties
        self.minefield = minefield
        exhaust?.position = CGPoint(x: 0, y: -12.5)
        exhaust?.setScale(0.12)
        size = CGSize(width: 10, height: 25)
        self.name = "mine"
        self.zPosition = 1
        
        //add to groups
        self.game.mines.append(self)
        
        //set physics
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Mine
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.fieldBitMask = PhysicsCategory.None
        
        
    }
    //MARK: - FUNCTIONALITY
    func autotarget(){
        let game = self.game
        let chunk = self.parent as! Chunk
        let dx = (self.position.x + chunk.gridPos.x*chunk.size.width) - game!.Player.position.x
        let dy = (self.position.y + chunk.gridPos.y*chunk.size.height) - game!.Player.position.y
        let rad = atan2(dy, dx)
        self.position.x += self.speed * -1 * cos(rad)
        self.position.y += self.speed * -1 * sin(rad)
        let rotate = SKAction.rotate(toAngle: rad + CGFloat(Double.pi/2), duration: 0.1, shortestUnitArc: true)
        self.run(rotate)
        
        //self.zRotation = rad + CGFloat(M_PI/2)
        self.speed += 0.001 * self.acceleration
        self.acceleration += 2
        
        //add exhaust
        if !self.exhaustshown{
            self.addChild(exhaust!)
            self.exhaustshown = true
        }
        
        
        
    }
    func explode(){
        print("  <*> exploded")
        self.exploded = false
        self.activated = false
        self.game.mines.remove(at: self.game.mines.index(of: self)!)
        self.removeFromParent()
    }
    
    //MARK: - UPDATE
    func update(){
        if self.activated == true{
            autotarget()
        }
        if self.exploded{
            explode()
        }
    }
}
