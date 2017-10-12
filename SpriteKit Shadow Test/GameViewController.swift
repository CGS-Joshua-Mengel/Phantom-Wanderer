//
//  GameViewController.swift
//  SpriteKit Shadow Test
//
//  Created by Edan Reynolds on 31/7/17.
//  Copyright © 2017 Edan Reynolds. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var movementLabel: String!
    
    var attackLabel: String!
    
    var firingDirection: String!
    
    var myScene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                myScene = scene as? GameScene
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func playerMovement(sender: UIButton) {
        
        movementLabel = sender.titleLabel?.text
                
        myScene.playerMove(label: movementLabel)
        
    }
    
    @IBAction func playerAttacking(sender: UIButton) {
        
        attackLabel = sender.titleLabel?.text
        
        myScene.playerAttack(attackDirection: attackLabel)
        
    }
    
    @IBAction func regenerate(_ sender: Any) {
        myScene.regenerate()
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
