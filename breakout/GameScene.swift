//
//  GameScene.swift
//  breakout
//
//  Created by Student on 3/9/17.
//  Copyright © 2017 bhs. All rights reserved.
//test

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var brick: SKSpriteNode!
    var brickHit = 0
    var countBalls = 0
    var playLabel = SKLabelNode()
    var livesLabel = SKLabelNode()
    // var myField: UITextField = UITextField(frame: CGRect(x: 10, y: 10, width: 30, height: 10))
    //var brickArray = []()
    var playingGame = false
    
    let button = UIButton(frame: CGRect(x: 100, y: 600, width: 100, height: 100))
    button.backgroundColor.UIColor.greenColor()
    button.backgroundColor = UIColor.red
    button.setTitle("Test Button", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    self.view.addSubview(button)
    
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        //constraint around edge of view
        createBackground()
        makeBall()
        makePaddle()
        makeBlock()
       // makeBrick()
        //removeBrick()
        makeLoseZone()
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "brick"
        {
            print("brick hit")
            brickHit += 1
            contact.bodyA.node?.removeFromParent()
            
        }
        if contact.bodyB.node?.name == "brick"
        {
            print("brick hit")
            brickHit += 1
            contact.bodyB.node?.removeFromParent()
            
        }
        else if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("You Lose")
        }
        
    }

    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall()
    {
        let ballDiameter = frame.width / 20
        
        ball = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX + 20, y: frame.midY)
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 2, dy: 2))//puts ball in motion
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        addChild(ball)
    }
    func makePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)

    }
    func makeLoseZone()
    {
        
        let loseZone = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height:50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
        //ball count
//        if brick.position == loseZone.position
//        {
//            countBalls += 1
//            
//        }
//        
//         if countBalls == 3
//         {
        func gameOver(winner: Bool)
        {
            playingGame = false
        
            playLabel.text = "You Lose. Tap to play again."
        
        
    }
    func makeBrick(xPoint: Int, yPoint: Int, brickWidth: Int, brickHeight: Int)
    {
       brick = SKSpriteNode(color: UIColor.magenta, size: CGSize(width: brickWidth, height: brickHeight))
       brick.position = CGPoint(x: xPoint, y: yPoint)
       brick.name = "brick"
       brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
       brick.physicsBody?.isDynamic = false
    addChild(brick)
    }
    
   func makeBlock()
   {
        //need loop for each time that goes through moves position (x, y) at end x += 15
        
        var xPosition = Int (frame.midX - (frame.width / 2))
        var yPosition = 150
        // var count = 0
        var blockWidth = (Int)((frame.width - 60) / 5)
        var blockHeight = 20

        
        for rows in 1...3
        {
            for columns in 1...5
            {
                makeBrick(xPoint: xPosition, yPoint: yPosition, brickWidth: blockWidth, brickHeight: blockHeight)
                xPosition += (blockWidth + 10)
            }
            xPosition = Int(frame.midX - (frame.width / 2))
            yPosition += (blockHeight + 10)
            
                
            
            }
    
            
        }
    func makeLabel()
    {
        playLabel.position = CGPoint(x: frame.midX,y: frame.midY - 50)
        playLabel.name = "play"
        addChild(playLabel)
        
        livesLabel.fontSize = 18
        livesLabel.fontColor = UIColor.black
        livesLabel.fontName = "Arial"
        livesLabel.position = CGPoint(x: frame.minX + 50, y: frame.minY + 18)
        addChild(livesLabel)
    }
    func buttonAction(sender: UIButton!)
    {
        print("Button tapped")
        
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
    }

    

}


    
    
    
