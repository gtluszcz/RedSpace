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
    var collisions: Collisions!
    var globalseed = GKARC4RandomSource()
    var joystickone = Joystick()
    var joysticktwo = Joystick()
    var fingerone = [UITouch]()
    var fingertwo = [UITouch]()
    
    //Groups
    var allsprites = [Any]()
    var chunks = [Chunk]()
    var planets = [Planet]()
    var minefields = [Minefield]()
    var mines = [Mine]()
    var asteroids = [Asteroid]()
    var asteroidfields = [AsteroidField]()
    var lasers = [Laser]()
    var enemies = [Enemy]()

    var debug = false
    //MARK: - INIT
    
    override init(size: CGSize) {
        super.init(size: size)
        
        Player = Spaceship(scene: self, size: size)
        print(globalseed)
        
        //creating chunks
        for i in 0...1{
            for j in 0...1{
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
        
        //setting camera
        let followPlayer = SKConstraint.distance(SKRange(constantValue: 0), to: self.Player)
        cameraNode.constraints = [followPlayer]
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        //add player on screen
        self.addChild(Player)
        
        //set star background
        Starfield = SKEmitterNode(fileNamed: "Starfield")
        Starfield.zPosition = -1
        Starfield.constraints = [followPlayer]
        self.addChild(Starfield)
        
        //set collisions logic
        collisions = Collisions(game: self)
        
        //set physics world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        
        //setting coordinate system
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.anchorPoint = anchorPoint
        
        
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
            if joystickone.inParentHierarchy(self) == false && touch.location(in: self).x < (self.camera?.position.x)!{
                print("                                        joystick 1 enabled")
                joystickone = Joystick(scene: self, radius: 40, position: touch.location(in: self.camera!))
                fingerone.insert(touch, at: 0)
                self.cameraNode.addChild(joystickone)
            }
            if joysticktwo.inParentHierarchy(self) == false && touch.location(in: self).x > (self.camera?.position.x)!{
                print("                                        joystick 2 enabled")
                joysticktwo = Joystick(scene: self, radius: 40, position: touch.location(in: self.camera!))
            
                fingertwo.insert(touch, at: 0)
                self.cameraNode.addChild(joysticktwo)
            }
        }
//        print("touch")
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
                    print("                                        joystick 1 disabled")
                }
            }
            if !fingertwo.isEmpty{
                if touch == fingertwo[0]{
                    joysticktwo.removeAllChildren()
                    joysticktwo.removeFromParent()
                    fingertwo.remove(at: 0)
                    print("                                        joystick 2 disabled")
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
                    print("                                        joystick 1 disabled")
                }
            }
            if !fingertwo.isEmpty{
                if touch == fingertwo[0]{
                    joysticktwo.removeAllChildren()
                    joysticktwo.removeFromParent()
                    fingertwo.remove(at: 0)
                    print("                                        joystick 2 disabled")
                }
            }
        }
    }
    
    //MARK: - CONTACT
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Handle Spaceship collision with  Minefield
        if collision == PhysicsCategory.Minefield | PhysicsCategory.Player{
            collisions.contactPlayerBombfield(contact: contact)
        }
        
        // Handle Spaceship collision with Minefield
        else if collision == PhysicsCategory.Mine | PhysicsCategory.Player{
            collisions.contactPlayerMine(contact: contact)
        }
        
        // Handle Laser collision with Asteroid
        else if collision == PhysicsCategory.Laser | PhysicsCategory.Asteroid{
            collisions.contactLaserAsteroid(contact: contact)
        }
            
        // Handle Laser collision with Planet
        else if collision == PhysicsCategory.Laser | PhysicsCategory.Planet{
            collisions.contactLaserPlanet(contact: contact)
        }

        // Handle Laser collision with Mine
        else if collision == PhysicsCategory.Laser | PhysicsCategory.Mine{
            collisions.contactLaserMine(contact: contact)
        }
        
        // Handle Laser collision with Player
        else if collision == PhysicsCategory.Laser | PhysicsCategory.Player{
            collisions.contactLaserPlayer(contact: contact)
        }
        // Handle Laser collision with Enemy
        else if collision == PhysicsCategory.Laser | PhysicsCategory.Enemy{
            collisions.contactLaserEnemy(contact: contact)
        }



    }

    
    //MARK: - UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        handlejoysticks()
        allnodesupdate()
        updateChunks()
      
    }
    
    func handlejoysticks(){
        if !fingerone.isEmpty && !fingertwo.isEmpty{
            Player.moveToTouchLocation(touch: fingerone[0], joystick: joystickone, joysticktwo: joysticktwo)
            Player.roatetotouch(touch: fingertwo[0], joystick: joysticktwo)
            Player.shootlasers()
        }
        else if !fingerone.isEmpty && fingertwo.isEmpty{
            Player.moveToTouchLocation(touch: fingerone[0], joystick: joystickone)
            Player.roatetotouch(touch: fingerone[0], joystick: joystickone)
        }
        else if fingerone.isEmpty && !fingertwo.isEmpty {
            Player.roatetotouch(touch: fingertwo[0], joystick: joysticktwo)
            Player.enginesoff()
            Player.shootlasers()
        }
        else if fingerone.isEmpty && fingertwo.isEmpty {
            Player.enginesoff()
        }
    }
    
    func updateChunks(){

        for chunk in chunks{
            var gridx = chunk.gridPos.x
            var gridy = chunk.gridPos.y
            let lastposx = gridx
            let lastposy = gridy
            
            // Chunk movement to symulate infinite world
            if Player.position.x - chunk.position.x > 1 * chunk.size.width {
                gridx += 2
            }
            else if Player.position.x - chunk.position.x < -1 * chunk.size.width {
                gridx += -2
            }
            if Player.position.y - chunk.position.y > 1 * chunk.size.height {
                gridy += 2
            }
            else if Player.position.y - chunk.position.y < -1 * chunk.size.height {
                gridy += -2
            }
            if lastposx != gridx || lastposy != gridy {
                emptychunk(target: chunk)
                chunk.moveTo(gridx: gridx, gridy: gridy)
                chunk.addobjects(seed: globalseed.seed)
            }
            
            
        }
        
    }
    func allnodesupdate(){
        Player.update()
        for chunk in self.chunks{chunk.update()}
        for planet in self.planets{planet.update()}
        for minefield in self.minefields{minefield.update()}
        for mine in self.mines{mine.update()}
        for asteroidfield in self.asteroidfields{asteroidfield.update()}
        for asteroid in self.asteroids{asteroid.update()}
        for laser in self.lasers{laser.update()}
        for enemy in self.enemies{enemy.update()}
        
        
    }
    
    func emptychunk(target: SKNode){
        for child in target.children{
            emptychunk(target: child)
            child.removeFromParent()
        }
        switch target {
        case let somePlanet as Planet:
            let index = planets.index(of: somePlanet)
            if (index != nil){
                    planets.remove(at: index!)
            }
        case let someAsteroid as Asteroid:
            let index = asteroids.index(of: someAsteroid)
            if (index != nil){
                asteroids.remove(at: index!)
            }
        case let someAsteroidField as AsteroidField:
            let index = asteroidfields.index(of: someAsteroidField)
            if (index != nil){
                asteroidfields.remove(at: index!)
            }
        case let someMine as Mine:
            let index = mines.index(of: someMine)
            if (index != nil){
                mines.remove(at: index!)
            }
        case let someMineField as Minefield:
            let index = minefields.index(of: someMineField)
            if (index != nil){
                minefields.remove(at: index!)
            }
        case let someEnemy as Enemy:
            let index = enemies.index(of: someEnemy)
            if (index != nil){
                enemies.remove(at: index!)
            }
        default: break
        }
        
    }
    
    
}












