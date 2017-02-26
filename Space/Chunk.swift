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
    
    
    //MARK: - INIT
    
    init(scene: GameScene, gridx: Int, gridy: Int, viewsize: CGSize){
        let hue = CGFloat(arc4random() % 255) / 255
        let sizetmp = CGSize(width: viewsize.height, height: viewsize.height)
        super.init(texture: nil, color: UIColor(red: hue, green: hue, blue: hue, alpha: 255), size: sizetmp)
        setup(gridx: gridx, gridy: gridy)
        
        
        /// Testing positions textbox
        let textbox = SKLabelNode(text: String(gridx)+":"+String(gridy))
        textbox.fontSize = 200
        textbox.zPosition = 99
        textbox.fontColor = UIColor.orange
        textbox.horizontalAlignmentMode = .center
        textbox.verticalAlignmentMode = .center
        addChild(textbox)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SETUP
    
    func setup(gridx: Int, gridy: Int) {
        moveTo(gridx: gridx, gridy: gridy)
    }
    
    
    //MARK: - FUNCTIONALITY
    
    func moveTo(gridx: Int, gridy: Int) {
        
        self.gridPos = CGPoint(x: gridx, y: gridy)
        position.x = self.gridPos.x * self.size.width
        position.y = self.gridPos.y * self.size.height

    }
}
