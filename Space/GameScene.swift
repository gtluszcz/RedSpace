//
//  GameScene.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: GLOBALS
    var Starfield:SKEmitterNode!
    var Player = Spaceship()
    let cameraNode = SKCameraNode()
    var chunks = [Chunk]()
    var globalseed : Int=Int(arc4random() % 1000)
    
    //MARK: - INIT
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        //creating chunks
        for i in -1...1{
            for j in -1...1{
                let chunk = Chunk(scene: self, gridx: CGFloat(i), gridy: CGFloat(j), viewsize: size, seed: globalseed)
                chunks.append(chunk)
            }
        }
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    func setup(){
        //add player on screen
        self.addChild(Player)
        
        //set star background
        Starfield = SKEmitterNode(fileNamed: "Starfield")
        self.addChild(Starfield)
        
        
        //set physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        //setting coordinate system
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.anchorPoint = anchorPoint
        
        //setting camera
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        //add chunks on screen
        for chunk in chunks{
            self.addChild(chunk)
        }
    }
    
    override func didMove(to view: SKView) {
        

    }
    
    //MARK: - TOUCHES
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            Player.moveToTouchLocation(touch: touch, scene: self)
        }
    }
    
    //MARK: - UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.camera!.position = Player.position
        Starfield.position = Player.position
        updateChunks()
    }
    
    func updateChunks(){

        for chunk in chunks{
            var gridx = chunk.gridPos.x
            var gridy = chunk.gridPos.y
            let lastposx = gridx
            let lastposy = gridy
            
            if Player.position.x - chunk.position.x > 2 * chunk.size.width {
                gridx += 3
            }
            else if Player.position.x - chunk.position.x < -2 * chunk.size.width {
                gridx += -3
            }
            if Player.position.y - chunk.position.y > 2 * chunk.size.height {
                gridy += 3
            }
            else if Player.position.y - chunk.position.y < -2 * chunk.size.height {
                gridy += -3
            }
            if lastposx != gridx || lastposy != gridy {
                chunk.removeAllChildren()
                chunk.moveTo(gridx: gridx, gridy: gridy)
                chunk.addobjects(seed: globalseed)
                
            }
            
            
        }
        
    }
    
    
    
}












