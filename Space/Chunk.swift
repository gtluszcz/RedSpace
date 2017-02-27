//
//  Chunk.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import SpriteKit
import Foundation

class Chunk: SKSpriteNode{
    
    //MARK: PROPERTIES
    
    var gridPos = CGPoint(x: 0, y: 0)
    var textbox = SKLabelNode()
    var dim : CGFloat = 0
    
    //MARK: - INIT
    
    init(scene: GameScene, gridx: CGFloat, gridy: CGFloat, viewsize: CGSize){
        
        var sizetmp = CGSize(width: viewsize.width, height: viewsize.width)
        if viewsize.height >= viewsize.width {
            sizetmp = CGSize(width: viewsize.height, height: viewsize.height)
        }
        super.init(texture: nil, color: UIColor.clear, size: sizetmp)
        
        setup(gridx: gridx, gridy: gridy)
        
        //Bounding edges
        let path = CGPath(rect: self.frame, transform: nil)
        let outline = SKShapeNode(path: path)
        outline.strokeColor = UIColor.black
        addChild(outline)
        
        
        /// Testing positions textbox
        textbox = SKLabelNode(text: String(Int(gridx))+":"+String(Int(gridy)))
        textbox.fontSize = 60
        textbox.zPosition = 99
        textbox.fontColor = UIColor.white
        textbox.horizontalAlignmentMode = .center
        textbox.verticalAlignmentMode = .center
        addChild(textbox)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    
    func setup(gridx: CGFloat, gridy: CGFloat) {
        self.dim = self.size.width / 100
        moveTo(gridx: gridx, gridy: gridy)
        addobjects()
    }
    
    
    //MARK: - FUNCTIONALITY
    
    func moveTo(gridx: CGFloat, gridy: CGFloat) {
        
        self.gridPos = CGPoint(x: gridx, y: gridy)
        position.x = self.gridPos.x * self.size.width
        position.y = self.gridPos.y * self.size.height
        textbox.text = String(Int(gridx))+":"+String(Int(gridy))

    }
    
    func addobjects(){
        let randx = CGFloat(arc4random() % UInt32(self.size.width)/2)
        let randy = CGFloat(arc4random() % UInt32(self.size.width)/2)
        let randsize = CGFloat(arc4random() % UInt32(self.size.width)/4)
        let tmppoint = CGPoint(x: randx, y: randy)
        let planeta = Planet(radius: randsize, position: tmppoint, color: UIColor.red)
        self.addChild(planeta)
    }
}
