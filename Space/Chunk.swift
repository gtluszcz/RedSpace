//
//  Chunk.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//
import GameKit
import SpriteKit
import Foundation

class Chunk: SKSpriteNode{
    
    //MARK: PROPERTIES
    
    var gridPos = CGPoint(x: 0, y: 0)
    var textbox = SKLabelNode()
    var dim : CGFloat = 0
    
    //MARK: - INIT
    
    init(scene: GameScene, gridx: CGFloat, gridy: CGFloat, viewsize: CGSize, seed: Int){
        
        var sizetmp = CGSize(width: viewsize.width, height: viewsize.width)
        if viewsize.height >= viewsize.width {
            sizetmp = CGSize(width: viewsize.height, height: viewsize.height)
        }
        super.init(texture: nil, color: UIColor.clear, size: sizetmp)
        
        setup(gridx: gridx, gridy: gridy, seed: seed)
    
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    
    func setup(gridx: CGFloat, gridy: CGFloat, seed: Int) {
        self.dim = self.size.width / 100
        moveTo(gridx: gridx, gridy: gridy)
        addobjects(seed: seed)
    }
    
    
    //MARK: - FUNCTIONALITY
    
    func moveTo(gridx: CGFloat, gridy: CGFloat) {
        
        self.gridPos = CGPoint(x: gridx, y: gridy)
        position.x = self.gridPos.x * self.size.width
        position.y = self.gridPos.y * self.size.height
        
    }
    
    func addobjects(seed: Int){
        /// Testing positions textbox
        textbox = SKLabelNode(text: String(Int(self.gridPos.x))+":"+String(Int(self.gridPos.y)))
        textbox.fontSize = 60
        textbox.zPosition = 99
        textbox.fontColor = UIColor.white
        textbox.horizontalAlignmentMode = .center
        textbox.verticalAlignmentMode = .center
        self.addChild(textbox)
        
        //Bounding edges
        let path = CGPath(rect: self.frame, transform: nil)
        let outline = SKShapeNode(path: path)
        outline.strokeColor = UIColor.black
        outline.zPosition = 99
        addChild(outline)
        outline.position.x = -1 * self.position.x
        outline.position.y = -1 * self.position.y
        

        //setting the random number generator
        let rs = GKMersenneTwisterRandomSource()
        rs.seed = UInt64(seed + Int(self.gridPos.x) * 10 + Int(self.gridPos.y))
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: (Int(self.size.width) / Int(-4)), highestValue: (Int(self.size.width) / Int(4)))
        
        
        //make the division point
        let randx = CGFloat(rd.nextInt())
        let randy = CGFloat(rd.nextInt())
        let divisionPoint = CGPoint(x: randx, y: randy)
        
        //let planet1 = Planet(radius: 3, position: divisionPoint, color: UIColor.green)
        //self.addChild(planet1)
    
        
        //generate object in divided uper-left section
        let upLeftCenter = CGPoint(x: ((self.size.width / -2)), y: ((self.size.height / 2)))
        makeobject(lpoint: upLeftCenter, rpoint: divisionPoint, seed: rs.seed,  random: rs)
        
        //generate object in divided bottom-left section
        let downLeftCenter = CGPoint(x: ((self.size.width / -2)), y: ((self.size.height / -2)))
        makeobject(lpoint: divisionPoint, rpoint: downLeftCenter, seed: rs.seed, random: rs)
        
        //generate object in divided upper-right section
        let upRightCenter = CGPoint(x: ((self.size.width / 2)), y: ((self.size.height / 2)))
        makeobject(lpoint: upRightCenter, rpoint: divisionPoint, seed: rs.seed,  random: rs)
        
        //generate object in divided bottom-right section
        let downRightCenter = CGPoint(x: ((self.size.width / 2)), y: ((self.size.height / -2)))
        makeobject(lpoint: downRightCenter, rpoint: divisionPoint, seed: rs.seed, random: rs)
        
        
    }
    
    func makeobject(lpoint: CGPoint, rpoint: CGPoint, seed: UInt64, random: GKRandomSource){
        //measure container
        let recwidth = abs(lpoint.x - rpoint.x)
        let recheight = abs(lpoint.y - rpoint.y)
        let reccenter = CGPoint(x: (lpoint.x + rpoint.x) / 2, y: (lpoint.y + rpoint.y) / 2)
        let recsize = min(recwidth, recheight)
        
        
        //let planet1 = Planet(radius: 3, position: reccenter, color: UIColor.yellow)
        //self.addChild(planet1)
        
        //make random
        let rd = GKRandomDistribution(randomSource: random, lowestValue: (Int(recsize) / Int(-4)), highestValue: (Int(recsize) / Int(4)))
        
        //measure object position
        let objcenter = CGPoint(x: reccenter.x + CGFloat(rd.nextInt()), y: reccenter.y + CGFloat(rd.nextInt()))
        let objradius = min(abs(lpoint.x - objcenter.x),abs(lpoint.y - objcenter.y),abs(rpoint.x - objcenter.x),abs(rpoint.y - objcenter.y))
        
        //radnomize objects
        let rd2 = GKRandomDistribution(randomSource: random, lowestValue: 0, highestValue: 999)
        let tmp = rd2.nextInt()
        if tmp > 800 {
            let planet = Planet(radius: objradius, position: objcenter, color: UIColor.purple, unit: self.dim)
            self.addChild(planet)
        }
        else if tmp > 500 && tmp <= 800 {
            let bomb = Bombfield(position: objcenter, maxradius: objradius, unit: self.dim)
            self.addChild(bomb)
        }
        
    }
    
}
