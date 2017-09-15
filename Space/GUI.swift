//
//  gui_healthandshieldbar.swift
//  Space
//
//  Created by Henryk Tłuszcz on 12.09.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GUI: UIView {
    
    //MARK: PROPERTIES
    var game: GameScene!
    
    var healthtext: CGRect!
    var shieldtext: CGRect!
    var healthbar: CGRect!
    var shieldbar: CGRect!
    
    
    init(frame: CGRect, game: GameScene) {
        super.init(frame: frame)
        self.game = game
        self.healthtext =  frame
        self.shieldtext =  frame
        self.healthbar =  frame
        self.shieldbar =  frame

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        Healthandshieldbar.drawCanvas1(frame: self.bounds,resizing: .aspectFit, game: self.game)
    }
    
        

}
