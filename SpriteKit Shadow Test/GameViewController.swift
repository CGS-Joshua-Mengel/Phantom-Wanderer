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
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var lifeDisplay: UIImageView!
    
    func updatePlayerLife(_ life: Int) {
        
        switch life {
            
        case 1:
            lifeDisplay.image = UIImage(named: "HeartOne")
            
        case 2:
            lifeDisplay.image = UIImage(named: "HeartTwo")
            
        case 3:
            lifeDisplay.image = UIImage(named: "HeartThree")
            
        case 4:
            lifeDisplay.image = UIImage(named: "HeartFour")
            
        case 5:
            lifeDisplay.image = UIImage(named: "HeartFive")
            
        default:
            break
            
        }
        
    }
    
    @IBOutlet weak var overallScoreLabel: UILabel!
    
    func updateOverallScore(_ score: Int) {
        
        overallScoreLabel.text = "Score: \(score)"
        
    }
    
    var movementLabel: String!
    
    var attackLabel: String!
    
    var firingDirection: String!
    
    var myScene: GameScene!
    
    var selfView: GameViewController!
    
    @IBOutlet var overallView: SKView!
    
    
    @IBOutlet weak var gamePausedImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var attackLeft: UIButton!
    @IBOutlet weak var attackDown: UIButton!
    @IBOutlet weak var attackRight: UIButton!
    @IBOutlet weak var attackUp: UIButton!
    
    @IBOutlet weak var arrowUp: UIButton!
    @IBOutlet weak var arrowRight: UIButton!
    @IBOutlet weak var arrowDown: UIButton!
    @IBOutlet weak var arrowLeft: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // hides button when view loads
        continueButton.isHidden = true
        titleButton.isHidden = true
        
        // disables button when view loads
        continueButton.isEnabled = false
        titleButton.isEnabled = false
        
        gamePausedImage.isHidden = true
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                myScene = scene as? GameScene
                
                myScene.gameViewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func pause(_ sender: Any) {
        
        overallView.isPaused = true
        //overallView.tintColor = UIColor.darkGray
        
        gamePausedImage.isHidden = false
        continueButton.isHidden = false
        titleButton.isHidden = false
        
        continueButton.isEnabled = true
        titleButton.isEnabled = true
        
        attackUp.isEnabled = false
        attackDown.isEnabled = false
        attackLeft.isEnabled = false
        attackRight.isEnabled = false
        
        arrowUp.isEnabled = false
        arrowDown.isEnabled = false
        arrowLeft.isEnabled = false
        arrowRight.isEnabled = false
    }
    
    @IBAction func continueAgain(_ sender: Any) {
        
        overallView.isPaused = false
        //overallView.tintColor = UIColor.clear
        
        gamePausedImage.isHidden = true
        continueButton.isHidden = true
        titleButton.isHidden = true
        
        continueButton.isEnabled = false
        titleButton.isEnabled = false
        
        attackUp.isEnabled = true
        attackDown.isEnabled = true
        attackLeft.isEnabled = true
        attackRight.isEnabled = true
        
        arrowUp.isEnabled = true
        arrowDown.isEnabled = true
        arrowLeft.isEnabled = true
        arrowRight.isEnabled = true
    }
    
    func highScore(_ score: Int) {
        print(score)
    }
    
    
    @IBAction func playerMovement(sender: UIButton) {
        
        movementLabel = sender.titleLabel?.text
        
        myScene.playerMove(label: movementLabel)
        
    }
    
    @IBAction func playerAttacking(sender: UIButton) {
        
        attackLabel = sender.titleLabel?.text
        
        myScene.playerAttack(attackDirection: attackLabel)
        
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
