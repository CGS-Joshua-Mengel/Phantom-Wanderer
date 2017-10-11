//
//  GameScene.swift
//  SpriteKit Shadow Test
//
//  Created by Edan Reynolds on 31/7/17.
//  Copyright © 2017 Edan Reynolds. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var northDeadEnd = allRooms.northDeadEnd
    
    var upList = [1,5,7,8,11,12,13,15]
    var downList = [3,5,9,10,12,13,14,15]
    var leftList = [2,6,8,9,11,12,14,15]
    var rightList = [4,6,7,10,11,13,14,15]
    
    var floor = [
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
    
    func makeFloor(y:Int, x:Int, prev:String) {
        
        var doup = 0
        var dodown = 0
        var doleft = 0
        var doright = 0
        
        if (y > 0 && floor[y-1][x] != 0) {
            if downList.contains(floor[y-1][x]) == false {
                doup = 1
            } else if downList.contains(floor[y-1][x]) == true {
                doup = 2
            }
        } else if y == 0 {
            doup = 1
        }
        if (y < 6 && floor[y+1][x] != 0) {
            if upList.contains(floor[y+1][x]) == false {
                dodown = 1
            } else if upList.contains(floor[y+1][x]) == true {
                dodown = 2
            }
        } else if y == 6 {
            dodown = 1
        }
        if (x > 0 && floor[y][x-1] != 0) {
            if rightList.contains(floor[y][x-1]) == false {
                doleft = 1
            } else if rightList.contains(floor[y][x-1]) == true {
                doleft = 2
            }
        } else if x == 0 {
            doleft = 1
        }
        if (x < 6 && floor[y][x+1] != 0) {
            if leftList.contains(floor[y][x+1]) == false {
                doright = 1
            } else if leftList.contains(floor[y][x+1]) == true {
                doright = 2
            }
        } else if x == 6 {
            doright = 1
        }
        
        var ranNum = 0
        
        while floor[y][x] == 0 {
            ranNum = Int(arc4random_uniform(8))
            if prev == "down" {
                if (upList.contains(downList[ranNum]) && doup == 1) || (leftList.contains(downList[ranNum]) && doleft == 1) || (rightList.contains(downList[ranNum]) && doright == 1) {
                    
                } else if (upList.contains(downList[ranNum]) == false && doup == 2) || (leftList.contains(downList[ranNum]) == false && doleft == 2) || (rightList.contains(downList[ranNum]) == false && doright == 2) {
                    
                } else {
                    floor[y][x] = downList[ranNum]
                }
            } else if prev == "up" {
                if (downList.contains(upList[ranNum]) && dodown == 1) || (leftList.contains(upList[ranNum]) && doleft == 1) || (rightList.contains(upList[ranNum]) && doright == 1) {
                    
                } else if (downList.contains(upList[ranNum]) == false && dodown == 2) || (leftList.contains(upList[ranNum]) == false && doleft == 2) || (rightList.contains(upList[ranNum]) == false && doright == 2) {
                    
                } else {
                    floor[y][x] = upList[ranNum]
                }
            } else if prev == "right" {
                if (downList.contains(rightList[ranNum]) && dodown == 1) || (leftList.contains(rightList[ranNum]) && doleft == 1) || (upList.contains(rightList[ranNum]) && doup == 1) {
                    
                } else if (downList.contains(rightList[ranNum]) == false && dodown == 2) || (leftList.contains(rightList[ranNum]) == false && doleft == 2) || (upList.contains(rightList[ranNum]) == false && doup == 2) {
                    
                } else {
                    floor[y][x] = rightList[ranNum]
                }
            } else if prev == "left" {
                if (downList.contains(leftList[ranNum]) && dodown == 1) || (upList.contains(leftList[ranNum]) && doup == 1) || (rightList.contains(leftList[ranNum]) && doright == 1) {
                    
                } else if (downList.contains(leftList[ranNum]) == false && dodown == 2) || (upList.contains(leftList[ranNum]) == false && doup == 2) || (rightList.contains(leftList[ranNum]) == false && doright == 2) {
                    
                } else {
                    floor[y][x] = leftList[ranNum]
                }
            } else {
                floor[y][x] = Int(arc4random_uniform(15)) + 1
            }
        }
        
        var isup = false
        var isdown = false
        var isleft = false
        var isright = false
        if upList.contains(floor[y][x]) {
            isup = true
        }
        if downList.contains(floor[y][x]) {
            isdown = true
        }
        if leftList.contains(floor[y][x]) {
            isleft = true
        }
        if rightList.contains(floor[y][x]) {
            isright = true
        }
        if (y > 0 && floor[y-1][x] == 0 && isup == true) {
            makeFloor(y: y-1, x: x, prev: "down")
        }
        if (y < 6 && floor[y+1][x] == 0 && isdown == true) {
            makeFloor(y: y+1, x: x, prev: "up")
        }
        if (x > 0 && floor[y][x-1] == 0 && isleft == true) {
            makeFloor(y: y, x: x-1, prev: "right")
        }
        if (x < 6 && floor[y][x+1] == 0 && isright == true) {
            makeFloor(y: y, x: x+1, prev: "left")
        }
    }
    
    //
    //      M E C H A N I C S
    //
    
    //All variables
    
    var updatedPlayerPosition = CGPoint()
    var moveAction: SKAction!
    
    var randomRoomDecider: Int!
    
    var bgGroup3: SKTileGroup!
    
    var isMoving = false
    
    var bgNode = SKTileMapNode()
    var bgNodeRoof = SKTileMapNode()
    
    var playerPositionColumn = 24
    var playerPositionRow = 24
    
    var columnNo = 0
    var rowNo = 48
    
    var roofColumnNo = 0
    var roofRowNo = 48
    
    let playerSpeed: CGFloat = 150.0
    
    var player: SKSpriteNode!
    
    var lastTouch: CGPoint? = nil
    
    let playerWalkUpAtlas = SKTextureAtlas(named: "PlayerUp")
    let playerWalkUpOne = SKTexture(imageNamed: "PlayerUpOne")
    let playerWalkUpTwo = SKTexture(imageNamed: "PlayerUpTwo")
    let playerWalkUpThree = SKTexture(imageNamed: "PlayerUpThree")
    let playerWalkUpFour = SKTexture(imageNamed: "PlayerUpFour")
    
    let playerWalkRightAtlas = SKTextureAtlas(named: "PlayerRight")
    let playerWalkRightOne = SKTexture(imageNamed: "PlayerRightOne")
    let playerWalkRightTwo = SKTexture(imageNamed: "PlayerRightTwo")
    let playerWalkRightThree = SKTexture(imageNamed: "PlayerRightThree")
    let playerWalkRightFour = SKTexture(imageNamed: "PlayerRightFour")
    
    let playerWalkDownAtlas = SKTextureAtlas(named: "PlayerDown")
    let playerWalkDownOne = SKTexture(imageNamed: "PlayerDownOne")
    let playerWalkDownTwo = SKTexture(imageNamed: "PlayerDownTwo")
    let playerWalkDownThree = SKTexture(imageNamed: "PlayerDownThree")
    let playerWalkDownFour = SKTexture(imageNamed: "PlayerDownFour")
    
    let playerWalkLeftAtlas = SKTextureAtlas(named: "PlayerLeft")
    let playerWalkLeftOne = SKTexture(imageNamed: "PlayerLeftOne")
    let playerWalkLeftTwo = SKTexture(imageNamed: "PlayerLeftTwo")
    let playerWalkLeftThree = SKTexture(imageNamed: "PlayerLeftThree")
    let playerWalkLeftFour = SKTexture(imageNamed: "PlayerLeftFour")
    
    var facingUp = false
    var facingRight = false
    var facingDown = true
    var facingLeft = false
    
    var walkUpAnimation: SKAction!
    var walkRightAnimation: SKAction!
    var walkDownAnimation: SKAction!
    var walkLeftAnimation: SKAction!
    
    var roomToPlace = [
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
    
    var roomToPlaceRoof = [
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0]
    ]
    
    
    
    //Functions for making the player face different directions
    
    func animateUp() {
        if facingUp == true {
            player.run(walkUpAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                self.animateUp()
            }
        }
    }
    
    func animateRight() {
        if facingRight == true {
            player.run(walkRightAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                self.animateRight()
            }
        }
    }
    
    func animateDown() {
        if facingDown == true {
            player.run(walkDownAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                self.animateDown()
            }
        }
    }
    
    func animateLeft() {
        if facingLeft == true {
            player.run(walkLeftAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                self.animateLeft()
            }
        }
    }
    
    
    
    //Things that happen on startup
    
    override func didMove(to view: SKView) {
        
        let walkUpFrames = [playerWalkUpOne, playerWalkUpOne, playerWalkUpTwo, playerWalkUpThree, playerWalkUpThree, playerWalkUpFour]
        let walkRightFrames = [playerWalkRightOne, playerWalkRightOne, playerWalkRightTwo, playerWalkRightThree, playerWalkRightThree, playerWalkRightFour]
        let walkLeftFrames = [playerWalkLeftOne, playerWalkLeftOne, playerWalkLeftTwo, playerWalkLeftThree, playerWalkLeftThree, playerWalkLeftFour]
        let walkDownFrames = [playerWalkDownOne, playerWalkDownOne, playerWalkDownTwo, playerWalkDownThree, playerWalkDownThree, playerWalkDownFour]
        
        walkUpAnimation = SKAction.animate(with: walkUpFrames, timePerFrame: 0.25)
        walkRightAnimation = SKAction.animate(with: walkRightFrames, timePerFrame: 0.25)
        walkDownAnimation = SKAction.animate(with: walkDownFrames, timePerFrame: 0.25)
        walkLeftAnimation = SKAction.animate(with: walkLeftFrames, timePerFrame: 0.25)
        
        makeFloor(y: 3, x: 3, prev:"start")
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        
        setupMap()
        
        updateCamera()
        
        animateDown()
        
    }
    
    
    
    //Function for placing the map
    
    func setupMap() {
        
        let tileTexture1 = SKTexture(imageNamed: "Roof")
        let tileTexture2 = SKTexture(imageNamed: "Wall")
        let tileTexture3 = SKTexture(imageNamed: "Floor")
        
        let bgDefinition1 = SKTileDefinition(texture: tileTexture1, size: tileTexture1.size())
        let bgGroup1 = SKTileGroup(tileDefinition: bgDefinition1)
        
        let bgDefinition2 = SKTileDefinition(texture: tileTexture2, size: tileTexture2.size())
        let bgGroup2 = SKTileGroup(tileDefinition: bgDefinition2)
        
        let bgDefinition3 = SKTileDefinition(texture: tileTexture3, size: tileTexture3.size())
        bgGroup3 = SKTileGroup(tileDefinition: bgDefinition3)
        
        let tileSet = SKTileSet(tileGroups: [bgGroup1, bgGroup2, bgGroup3])
        bgNode = SKTileMapNode(tileSet: tileSet, columns: 49, rows: 49, tileSize: tileTexture1.size())
        bgNode.position = CGPoint(x: 0, y: 0)
        bgNode.setScale(1)
        
        bgNodeRoof = SKTileMapNode(tileSet: tileSet, columns: 49, rows: 49, tileSize: tileTexture1.size())
        bgNodeRoof.position = CGPoint(x: 0, y: Int(tileTexture1.size().height / 2))
        bgNodeRoof.setScale(1)
        
        bgNode.lightingBitMask = 1
        bgNodeRoof.lightingBitMask = 1
        
        for row in floor {
            
            for column in row {
                
                switch column {
                    
                case 1:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.northDeadEnd
                        roomToPlaceRoof = allRooms.northDeadEndRoof
                    default:
                        roomToPlace = allRooms.northDeadEndRoom
                        roomToPlaceRoof = allRooms.northDeadEndRoomRoof
                        
                    }
                    
                case 2:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.westDeadEnd
                        roomToPlaceRoof = allRooms.westDeadEndRoof
                    default:
                        roomToPlace = allRooms.westDeadEndRoom
                        roomToPlaceRoof = allRooms.westDeadEndRoomRoof
                        
                    }
                    
                case 3:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.southDeadEnd
                        roomToPlaceRoof = allRooms.southDeadEndRoof
                    default:
                        roomToPlace = allRooms.southDeadEndRoom
                        roomToPlaceRoof = allRooms.southDeadEndRoomRoof
                        
                    }
                    
                case 4:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.eastDeadEnd
                        roomToPlaceRoof = allRooms.eastDeadEndRoof
                    default:
                        roomToPlace = allRooms.eastDeadEndRoom
                        roomToPlaceRoof = allRooms.eastDeadEndRoomRoof
                        
                    }
                    
                case 5:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.verticalStraight
                        roomToPlaceRoof = allRooms.verticalStraightRoof
                    default:
                        roomToPlace = allRooms.verticalStraightRoom
                        roomToPlaceRoof = allRooms.verticalStraightRoomRoof
                        
                    }
                    
                case 6:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.horizontalStraight
                        roomToPlaceRoof = allRooms.horizontalStraightRoof
                    default:
                        roomToPlace = allRooms.horizontalStraightRoom
                        roomToPlaceRoof = allRooms.horizontalStraightRoomRoof
                        
                    }
                    
                case 7:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.northEast90
                        roomToPlaceRoof = allRooms.northEast90Roof
                    default:
                        roomToPlace = allRooms.northEast90Room
                        roomToPlaceRoof = allRooms.northEast90RoomRoof
                        
                    }
                    
                case 8:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.northWest90
                        roomToPlaceRoof = allRooms.northWest90Roof
                    default:
                        roomToPlace = allRooms.northWest90Room
                        roomToPlaceRoof = allRooms.northWest90RoomRoof
                        
                    }
                    
                case 9:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.southWest90
                        roomToPlaceRoof = allRooms.southWest90Roof
                    default:
                        roomToPlace = allRooms.southWest90Room
                        roomToPlaceRoof = allRooms.southWest90RoomRoof
                        
                    }
                    
                case 10:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.southEast90
                        roomToPlaceRoof = allRooms.southEast90Roof
                    default:
                        roomToPlace = allRooms.southEast90Room
                        roomToPlaceRoof = allRooms.southEast90RoomRoof
                        
                    }
                    
                case 11:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.northTJunction
                        roomToPlaceRoof = allRooms.northTJunctionRoof
                    default:
                        roomToPlace = allRooms.northTJunctionRoom
                        roomToPlaceRoof = allRooms.northTJunctionRoomRoof
                        
                    }
                    
                case 12:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.westTJunction
                        roomToPlaceRoof = allRooms.westTJunctionRoof
                    default:
                        roomToPlace = allRooms.westTJunctionRoom
                        roomToPlaceRoof = allRooms.westTJunctionRoomRoof
                        
                    }
                    
                case 13:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.eastTJunction
                        roomToPlaceRoof = allRooms.eastTJunctionRoof
                    default:
                        roomToPlace = allRooms.eastTJunctionRoom
                        roomToPlaceRoof = allRooms.eastTJunctionRoomRoof
                        
                    }
                    
                case 14:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.southTJunction
                        roomToPlaceRoof = allRooms.southTJunctionRoof
                    default:
                        roomToPlace = allRooms.southTJunctionRoom
                        roomToPlaceRoof = allRooms.southTJunctionRoomRoof
                        
                    }
                    
                case 15:
                    
                    randomRoomDecider = Int(arc4random_uniform(2))
                    
                    switch randomRoomDecider {
                        
                    case 1:
                        roomToPlace = allRooms.xJunction
                        roomToPlaceRoof = allRooms.xJunctionRoof
                    default:
                        roomToPlace = allRooms.xJunctionRoom
                        roomToPlaceRoof = allRooms.xJunctionRoomRoof
                        
                    }
                    
                default:
                    
                    roomToPlace = allRooms.void
                    roomToPlaceRoof = allRooms.voidRoof
                    
                }
                
                for i in roomToPlace {
                    
                    for j in i {
                        
                        switch j {
                        case 0:
                            bgNode.setTileGroup(bgGroup3, forColumn: columnNo, row: rowNo)
                        case 2:
                            bgNode.setTileGroup(bgGroup2, forColumn: columnNo, row: rowNo)
                        default:
                            break
                        }
                        columnNo += 1
                    }
                    columnNo -= 7
                    rowNo -= 1
                }
                
                for i in roomToPlaceRoof {
                    
                    for j in i {
                        
                        switch j {
                        case 1:
                            bgNodeRoof.setTileGroup(bgGroup1, forColumn: roofColumnNo, row: roofRowNo)
                        default:
                            break
                        }
                        roofColumnNo += 1
                    }
                    roofColumnNo -= 7
                    roofRowNo -= 1
                }
                
                columnNo += 7
                roofColumnNo += 7
                rowNo += 7
                roofRowNo += 7
                
            }
            
            rowNo -= 7
            roofRowNo -= 7
            columnNo = 0
            roofColumnNo = 0
            
        }
        
        self.addChild(bgNode)
        self.addChild(bgNodeRoof)
        
        bgNode.zPosition = 10
        bgNodeRoof.zPosition = 30
        
        player.zPosition = 20
        
        player.position = bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow)
        
    }
    
    
    
    //Function for the player moving
    
    func playerMove(label: String) {
        
        if isMoving == false {
            
            switch label {
                
            case "ArrowUp":
                
                //Change the direction the player is facing
                if facingUp != true {
                
                    facingUp = true
                    facingRight = false
                    facingDown = false
                    facingLeft = false
                
                    animateUp()
                    
                }
                
                //Only move if the tile you're moving to is dirt
                if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow + 1) == bgGroup3 {
                    
                    playerPositionRow += 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        
                        self.isMoving = false
                        
                    }
                    
                    player.run(moveAction)
                    
                }
                
            case "ArrowRight":
                
                if facingRight != true {
                
                    facingUp = false
                    facingRight = true
                    facingDown = false
                    facingLeft = false
                
                    animateRight()
                
                }
                    
                if bgNode.tileGroup(atColumn: playerPositionColumn + 1, row: playerPositionRow) == bgGroup3 {
                    
                    playerPositionColumn += 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        
                        self.isMoving = false
                        
                    }
                    
                    player.run(moveAction)
                    
                }
                
            case "ArrowDown":
                
                if facingDown != true {
                
                    facingUp = false
                    facingRight = false
                    facingDown = true
                    facingLeft = false
                
                    animateDown()
                
                }
                    
                if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow - 1) == bgGroup3 {
                    
                    playerPositionRow -= 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        
                        self.isMoving = false
                        
                    }
                    
                    player.run(moveAction)
                    
                }
                
            case "ArrowLeft":
                
                if facingLeft != true {
                    
                    facingUp = false
                    facingRight = false
                    facingDown = false
                    facingLeft = true
                    
                    animateLeft()
                    
                }
                
                if bgNode.tileGroup(atColumn: playerPositionColumn - 1, row: playerPositionRow) == bgGroup3 {
                    
                    playerPositionColumn -= 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        
                        self.isMoving = false
                        
                    }
                    
                    player.run(moveAction)
                    
                }
                
            default:
                break
                
            }
            
        }
        
    }
    
    //Function for the player attacking
    
    func playerAttack(attackDirection: String) {
        
        let attackSprite = SKSpriteNode()
        
        attackSprite.size = SKTexture(imageNamed: "SwordSwipeOne").size()
        attackSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        attackSprite.zPosition = 100
        
        //Frames for the sword swipe animation
        let swipeOne = SKTexture(imageNamed: "SwordSwipeOne")
        let swipeTwo = SKTexture(imageNamed: "SwordSwipeTwo")
        let swipeThree = SKTexture(imageNamed: "SwordSwipeThree")
        let swipeFour = SKTexture(imageNamed: "SwordSwipeFour")
        let swipeFive = SKTexture(imageNamed: "SwordSwipeFive")
        
        let attackFrames = [swipeOne, swipeTwo, swipeThree, swipeFour, swipeFive]
        
        let attackAnimation = SKAction.animate(with: attackFrames, timePerFrame: 0.05)
        
        switch attackDirection {
            
        case "AttackUp":
            
            //Changing the direction the player is facing
            if facingUp != true {
                
                facingUp = true
                facingRight = false
                facingDown = false
                facingLeft = false
                
                animateUp()
                
            }
            
            //Playing the animation of the sword swiping
            self.addChild(attackSprite)
            attackSprite.position = CGPoint(x: player.position.x, y: player.position.y + 32)
            attackSprite.zRotation = 0
            attackSprite.run(attackAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (timer) in
                attackSprite.removeFromParent()
            }
            
        case "AttackRight":
            
            if facingRight != true {
                
                facingUp = false
                facingRight = true
                facingDown = false
                facingLeft = false
                
                animateRight()
                
            }
            
            self.addChild(attackSprite)
            attackSprite.position = CGPoint(x: player.position.x + 32, y: player.position.y)
            attackSprite.zRotation = -1.57
            attackSprite.run(attackAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (timer) in
                attackSprite.removeFromParent()
            }
            
        case "AttackDown":
            
            if facingDown != true {
                
                facingUp = false
                facingRight = false
                facingDown = true
                facingLeft = false
                
                animateDown()
                
            }
            
            self.addChild(attackSprite)
            attackSprite.position = CGPoint(x: player.position.x, y: player.position.y - 32)
            attackSprite.zRotation = 3.14
            attackSprite.run(attackAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (timer) in
                attackSprite.removeFromParent()
            }
            
        case "AttackLeft":
            
            if facingLeft != true {
                
                facingUp = false
                facingRight = false
                facingDown = false
                facingLeft = true
                
                animateLeft()
                
            }
            
            self.addChild(attackSprite)
            attackSprite.position = CGPoint(x: player.position.x - 32, y: player.position.y)
            attackSprite.zRotation = 1.57
            attackSprite.run(attackAnimation)
            let _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (timer) in
                attackSprite.removeFromParent()
            }
            
        default:
            break
            
        }
    }

    //Functions for making the camera follow the player
    
    func updateCamera() {
        
        if let camera = camera {
            
            camera.position = CGPoint(x: player.position.x, y: player.position.y)
            
        }
    }
    
    //Update the camera every frame
    
    override func update(_ currentTime: TimeInterval) {
        
        updateCamera()
        
    }
}
