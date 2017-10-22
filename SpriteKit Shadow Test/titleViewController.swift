//
//  titleViewController.swift
//  Phantom Wanderer
//
//  Created by Joshua Mengel on 22/10/17.
//  Copyright © 2017 Edan Reynolds. All rights reserved.
//

import UIKit
import GameKit

class titleViewController: UIViewController,
GKGameCenterControllerDelegate
{
    
    //
    // NOTE: SCORE ONLY UPDATES IN GAMESCENE CONTROLLER NOT IN THIS VIEWCONTROLLER
    //
    
    // game centre variables
    var isGCEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    let LEADERBOARD_ID = "BS"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the GC authentication controller
        authenticateLocalPlayer()
    }
    
    // Game Centre AUTHENTICATION - written whilst following along to tutorial - https://code.tutsplus.com/tutorials/game-center-and-leaderboards-for-your-ios-app--cms-27488
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
                
            } else if (localPlayer.isAuthenticated) {
                // Load game center if player is logged in
                self.isGCEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print("Could not get leaderboard ID")
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // If game center is not enabled, disable GC
                self.isGCEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openHighScore(_ sender: Any) {
        
        // open game centre view
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
