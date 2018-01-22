//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Viktoriia Rohozhyna on 1/13/18.
//  Copyright © 2018 Viktoriia Rohozhyna. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

struct PhysicsCatagory {
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    var referenceOfGameViewController : GameViewController!
    var viewController : UIViewController!
    var scoreClass = Score()
    
    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    let scoreLbl = SKLabelNode()
    
    var died = Bool()
    var restartBTN = SKSpriteNode()
    var hightScoreBTN = SKSpriteNode()
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createScene(){
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: -2)
    
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            
        }
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 60
        self.addChild(scoreLbl)
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask  = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        
        
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.isDynamic = true
        
        Ghost.zPosition = 2
        
        
        self.addChild(Ghost)
        
        
        
        
        
        
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        createScene()
        
    }
    
    func createBTN(){
        
        restartBTN = SKSpriteNode(imageNamed: "RestartBtn")
        restartBTN.size = CGSize(width: 200, height: 100)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        hightScoreBTN = SKSpriteNode(imageNamed: "Highscores")
        hightScoreBTN.size = CGSize(width: 200, height: 100)
        hightScoreBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 150)
        hightScoreBTN.zPosition = 7
        hightScoreBTN.setScale(0)
        self.addChild(hightScoreBTN)
        hightScoreBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Score {
            
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        }
            
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                if score > scoreClass.minOfScores() || scoreClass.scores.capacity <= 5 {
                    addScore(score: score)
                }
                createBTN()
            }
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Ground || firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Ghost{
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                if score > scoreClass.minOfScores() {
                    addScore(score: score)
                }
                createBTN()
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            
            gameStarted =  true
            
            Ghost.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
        else{
            
            if died == true{
   
                
            }
            else{
                Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
            }
            
        }
        
        
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if died == true{
                if restartBTN.contains(location){
                    restartScene()
                }
                if hightScoreBTN.contains(location){
                    showScore()
                }
                
                
            }
            
        }
        
        
        
        
        
        
    }
    
    func createWalls(){
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        scoreNode.color = SKColor.blue
        
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 350)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        var randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(scoreNode)
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if gameStarted == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    var bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                        
                    }
                    
                }))
                
            }
            
            
        }
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
        
        self.viewController.present(passwordAllertController, animated: true, completion: nil)
        
    }
    
    func  showScore() {
        var mes = String()
        var items = [(key: String, value: Int)]()
        let passwordAllertController = UIAlertController(title: "Good Job", message: "This is table with supermans", preferredStyle: .alert)
        passwordAllertController.addAction(UIAlertAction(title: "OK, í`m done", style: .default, handler: nil))
       
        items = scoreClass.scores.sorted(by: { $0.value < $1.value })
        for i in items {
            mes += i.key + "  " + String(i.value) + "\n"
        }
        passwordAllertController.message = mes
        self.viewController.present(passwordAllertController, animated: true, completion: nil)
        
    }
    
}
