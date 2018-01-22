//
//  GameViewController.swift
//  Flappy Bird
//
//  Created by Viktoriia Rohozhyna on 1/13/18.
//  Copyright © 2018 Viktoriia Rohozhyna. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController{

    var scoreClass = Score()
    
    
//    override func viewWillLayoutSubviews() {
  //      super.viewWillLayoutSubviews()
        
    //    let view = self.view as! SKView
        
   //     if view.scene == nil {
   //         if case let view.scene = SKScene(fileNamed: "GameScene") {
   //             view.showsFPS = false
   //         view.showsNodeCount = false
   //         view.ignoresSiblingOrder = true
  //          let gameScene = GameScene(size: view.bounds.size)
  //          gameScene.scaleMode = SKSceneScaleMode.aspectFill
  //          view.presentScene(gameScene)
  //              gameScene.viewController = self
  //          }
  //  }
  //  }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
        
                let scene = GameScene(size: view.bounds.size)
                scene.scaleMode = .aspectFill                // Present the scene
                scene.referenceOfGameViewController = self                //let gameScene = GameScene(size: view.bounds.size)
                //gameScene.scaleMode = SKSceneScaleMode.aspectFill
                //view.presentScene(gameScene)
                //gameScene.viewController = self
        
                view.presentScene(scene)
                 scene.viewController = self
        
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
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
        return false
    }
    
    func  addScore(score: Int) {
        let passwordAllertController = UIAlertController(title: "Good Job", message: "Please write your name", preferredStyle: .alert)
        passwordAllertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction) in
            self.scoreClass.appendNewScore(newName: passwordAllertController.textFields![0].text!, newScore: score)
        }))
        passwordAllertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        passwordAllertController.addTextField { (passwordTextField)  in
            passwordTextField.placeholder = "Name"
        }
        
       // self.present(passwordAllertController, animated: true, completion: nil)
    }
    
}
