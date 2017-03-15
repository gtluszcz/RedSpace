//
//  GameScene.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //MARK: GLOBALS
    var Starfield:SKEmitterNode!
    var Player: Spaceship!
    let cameraNode = SKCameraNode()
    var globalseed = GKARC4RandomSource()
    var joystickone = SKShapeNode(circleOfRadius: 40)
    var joysticktwo = SKShapeNode(circleOfRadius: 40)
    var fingerone = [UITouch]()
    var fingertwo = [UITouch]()
    
    //Groups
    var chunks = [Chunk]()
    var bombfields = [Bombfield]()
    
    //MARK: - INIT
    
    override init(size: CGSize) {
        super.init(size: size)
        
        Player = Spaceship(scene: self)
        print(globalseed)
        
        //creating chunks
        for i in -1...1{
            for j in -1...1{
                let chunk = Chunk(scene: self, gridx: CGFloat(i), gridy: CGFloat(j), viewsize: size, seed: globalseed.seed)
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
        self.physicsWorld.contactDelegate = self
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if joystickone.inParentHierarchy(self) == false{
                print("joystick 1 enabled")
                joystickone.position = touch.location(in: self.camera!)
                joystickone.strokeColor = UIColor.white
                joystickone.lineWidth = 4
                joystickone.zPosition = 99
            
                let joystickpad = SKShapeNode(circleOfRadius: 25)
                joystickpad.fillColor = UIColor.white
                joystickpad.name = "pad"
                joystickpad.zPosition = 99
                joystickone.addChild(joystickpad)
        
                fingerone.insert(touch, at: 0)
                self.cameraNode.addChild(joystickone)
            }
            else if joystickone.inParentHierarchy(self) == true && joysticktwo.inParentHierarchy(self) == false{
                print("joystick 2 enabled")
                joysticktwo.position = touch.location(in: self.camera!)
                joysticktwo.strokeColor = UIColor.white
                joysticktwo.lineWidth = 4
                joysticktwo.zPosition = 99
            
                let joystickpad = SKShapeNode(circleOfRadius: 25)
                joystickpad.fillColor = UIColor.white
                joystickpad.name = "pad"
                joystickpad.zPosition = 99
                joysticktwo.addChild(joystickpad)
            
                fingertwo.insert(touch, at: 0)
                self.cameraNode.addChild(joysticktwo)
            }
        }
        print("touch")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if !fingerone.isEmpty{
                if touch == fingerone[0]{
                    fingerone[0] = touch
                }
            }
            if !fingertwo.isEmpty{
                if touch == fingertwo[0]{
                    fingertwo[0] = touch
                
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if !fingerone.isEmpty{
                if touch == fingerone[0]{
                    joystickone.removeAllChildren()
                    joystickone.removeFromParent()
                    fingerone.remove(at: 0)
                    print("joystick 1 disabled")
                }
            }
            if !fingertwo.isEmpty{
                if touch == fingertwo[0]{
                    joysticktwo.removeAllChildren()
                    joysticktwo.removeFromParent()
                    fingertwo.remove(at: 0)
                    print("joystick 2 disabled")
                }
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if !fingerone.isEmpty{
                if touch == fingerone[0]{
                    joystickone.removeAllChildren()
                    joystickone.removeFromParent()
                    fingerone.remove(at: 0)
                    print("joystick 1 disabled")
                }
            }
            if !fingertwo.isEmpty{
                if touch == fingertwo[0]{
                    joysticktwo.removeAllChildren()
                    joysticktwo.removeFromParent()
                    fingertwo.remove(at: 0)
                    print("joystick 2 disabled")
                }
            }
        }
    }
    
    //MARK: - CONTACT
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Handle Spaceship collision with Bombfield
        if collision == PhysicsCategory.Bombfield | PhysicsCategory.Player{
            contactPlayerBombfield(contact: contact)
        }

    }
    
    //Contact: Spaceship - Bombfield
    func contactPlayerBombfield(contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.Bombfield{
            var bombfield: Bombfield
            bombfield = contact.bodyB.node as! Bombfield
            bombfield.activate()
            print("contact")
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.Bombfield && contact.bodyB.categoryBitMask == PhysicsCategory.Player{
            var bombfield: Bombfield
            bombfield = contact.bodyA.node as! Bombfield
            bombfield.activate()
            print("contact")
        }
    }
    
    //MARK: - UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        handlejoysticks()
        self.camera!.position = Player.position
        Starfield.position = Player.position
        updateChunks()
        allnodesupdate()
    }
    
    func handlejoysticks(){
        if !fingerone.isEmpty && !fingertwo.isEmpty{
            Player.moveToTouchLocation(touch: fingerone[0], joystick: joystickone, joysticktwo: joysticktwo)
            Player.roatetotouch(touch: fingertwo[0], joystick: joysticktwo)
        }
        else if !fingerone.isEmpty && fingertwo.isEmpty{
            Player.moveToTouchLocation(touch: fingerone[0], joystick: joystickone)
            Player.roatetotouch(touch: fingerone[0], joystick: joystickone)
        }
        else if fingerone.isEmpty && !fingertwo.isEmpty {
            Player.moveToTouchLocation(touch: fingertwo[0], joystick: joysticktwo)
            Player.roatetotouch(touch: fingertwo[0], joystick: joysticktwo)
        }

    }
    
    func updateChunks(){

        for chunk in chunks{
            var gridx = chunk.gridPos.x
            var gridy = chunk.gridPos.y
            let lastposx = gridx
            let lastposy = gridy
            
            // Chunk movement to symulate infinite world
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
                chunk.addobjects(seed: globalseed.seed)
                
            }
            
            
        }
        
    }
    func allnodesupdate(){
        for child in self.children{
            let chunk =  child as? Chunk
            chunk?.update()
        }
    }
    
    
}












