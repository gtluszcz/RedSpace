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
    
    //MARK: - INIT
    
    init(scene: GameScene, gridx: CGFloat, gridy: CGFloat, viewsize: CGSize){
        var sizetmp = CGSize(width: viewsize.width, height: viewsize.width)
        if viewsize.height >= viewsize.width {
            sizetmp = CGSize(width: viewsize.height, height: viewsize.height)
        }
        super.init(texture: nil, color: UIColor.clear, size: sizetmp)
        setup(gridx: gridx, gridy: gridy)
        
        
        /// Testing positions textbox
        textbox = SKLabelNode(text: String(Int(gridx))+":"+String(Int(gridy)))
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
    
    func setup(gridx: CGFloat, gridy: CGFloat) {
        moveTo(gridx: gridx, gridy: gridy)
    }
    
    
    //MARK: - FUNCTIONALITY
    
    func moveTo(gridx: CGFloat, gridy: CGFloat) {
        
        self.gridPos = CGPoint(x: gridx, y: gridy)
        position.x = self.gridPos.x * self.size.width
        position.y = self.gridPos.y * self.size.height
        textbox.text = String(Int(gridx))+":"+String(Int(gridy))

    }
}
