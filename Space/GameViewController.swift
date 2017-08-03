//
//  GameViewController.swift
//  Space
//
//  Created by Henryk on 26.02.2017.
//  Copyright © 2017 Grzegorz Tłuszcz Team. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
       
        
        scene = GameScene(size: view.frame.size)
        let sKview = self.view as! SKView
        scene.scaleMode = .resizeFill
        

        
        sKview.ignoresSiblingOrder = true
        sKview.showsFPS = true
        sKview.showsNodeCount = true
        sKview.presentScene(scene)
        
            
        
        
    }
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if scene.debug == true{
                scene.debug = false
                
            }
            else if scene.debug == false{
                scene.debug = true
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
