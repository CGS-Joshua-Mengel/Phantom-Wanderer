//
//  highScoreViewController.swift
//  Phantom Wanderer
//
//  Created by Joshua Mengel on 24/10/17.
//  Copyright © 2017 Edan Reynolds. All rights reserved.
//

import UIKit

class highScoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateHighScore(scoreToUpdate: Int) {
        print(scoreToUpdate)
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
