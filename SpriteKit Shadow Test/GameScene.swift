//
//  GameScene.swift
//  SpriteKit Shadow Test
//
//  Created by Edan Reynolds on 31/7/17.
//  Copyright © 2017 Edan Reynolds. All rights reserved.
//

// Score = Levels complete (100 points) + Kills (5 point) + Money (Between 10 & 50)

import SpriteKit
import GameKit

class GameScene: SKScene {
    
    var storyBoardController: GameViewController!
    
    //
    //      D U N G E O N   L A Y O U T   G E N E R A T I O N
    //
    
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
    
    // Scoring stuff
    var overallScore = 0
    
    // Referencing parent view controller
    var gameViewController: GameViewController! = nil
    
    //Variables for the current floor, and min/max ranges of the floor size.
    var currentFloor = 1
    var rangeMin = 5
    var rangeMax = 10
    
    //The function that actually makes the floor.
    func makeFloor(y:Int, x:Int, prev:String) {
        
        //Sets the actual ranges relative to the current floor.
        if currentFloor < 40 {
            rangeMin = 4 + currentFloor
            rangeMax = 9 + currentFloor
        } else {
            rangeMin = 44
            rangeMax = 49
        }
        
        //Variables that determine whether or not the generation will continue in ___ direciton.
        var doup = 0
        var dodown = 0
        var doleft = 0
        var doright = 0
        
        //If statements that determine the values of the aforementioned variables.
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
        
        //Declaring the variable that determines what room will be used.
        var ranNum = 0
        
        //A loop that keeps selecting random room values until it chooses one that works properly given its surroundings.
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
        
        //Variables/IFs that check if the current room faces ___ direction.
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
        
        //The actual recursive element of this function : Call itself again in adjacent directions if the former variables are true.
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
    
    //Places an exit in a random room on the map, provided said room is not the centre.
    func placeStairs() {
        
        var hasPlaced = false
        var stairPosX = 0
        var stairPosY = 0
        while (hasPlaced == false) {
            stairPosX = Int(arc4random_uniform(7))
            stairPosY = Int(arc4random_uniform(7))
            if (stairPosX == 3 && stairPosY == 3) {
                
            } else if (floor[stairPosY][stairPosX] != 0) {
                floor[stairPosY][stairPosX] = 16
                hasPlaced = true
            }
        }
    }
    
    //Places loot on the map based on the amountOfLoot Variable. Does not place in the middle.
    //Also will not place upon the stairs or other loot positions.
    func placeLoot() {
        
        
        //The amount of chests on each floor, based off of the current floor maximum range divided by 5, rounded down.
        let amountOfLoot = rangeMax/5
        
        var hasPlaced = 0
        var lootPosX = 0
        var lootPosY = 0
        while (hasPlaced < amountOfLoot) {
            lootPosX = Int(arc4random_uniform(7))
            lootPosY = Int(arc4random_uniform(7))
            if (lootPosX == 3 && lootPosY == 3) {
                
            } else if (floor[lootPosY][lootPosX] != 0 && floor[lootPosY][lootPosX] != 16 && floor[lootPosY][lootPosX] != 17) {
                floor[lootPosY][lootPosX] = 17
                hasPlaced += 1
            }
        }
    }
    
    //The overall function controlling the makeFloor function and also 'enforcing' the floor sizes.
    func overallControl() {
        makeFloor(y: 3, x: 3, prev:"start")
        var count3 = 0
        var count4 = 0
        var count0 = 0
        
        //Checks the amount of rooms within the floor
        while count3 < floor.count {
            while count4 < floor[count3].count {
                if floor[count3][count4] != 0 {
                    count0 += 1
                }
                count4 = count4 + 1
            }
            count3 = count3 + 1
            count4 = 0
        }
        
        //Checks whether said amount of rooms fits within the range. If it isn't, it wipes it and re-gens.
        //Otherwise, it will generate the exit and loot as per normal
        if (count0 >= rangeMin && count0 <= rangeMax) {
            placeStairs()
            placeLoot()
        } else {
            floor = [
                [0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0]
            ]
            overallControl()
        }
    }
    
    //
    //      M E C H A N I C S
    //
    
    //All variables
    
    var skeletonFrames = [SKTexture]()
    var skeletonAnimation : SKAction!
    var skeletonAnimating = true
    
    var updatedPlayerPosition = CGPoint()
    var moveAction: SKAction!
    
    var randomRoomDecider: Int!
    
    var isMoving = false
    
    var bgNode = SKTileMapNode()
    var bgNodeRoof = SKTileMapNode()
    
    var playerPositionColumn = 24
    var playerPositionRow = 24
    
    var columnNo = 0
    var rowNo = 48
    
    var roofColumnNo = 0
    var roofRowNo = 48
    
    let player = SKSpriteNode()
    let playerTexture = SKTexture(imageNamed: "PlayerDownOne")
    let playerLight = SKLightNode()
    let playerCamera = SKCameraNode()
    var playerHealth = 3
    
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
    
    let blackOutCurtain = SKSpriteNode()
    
    func createBlackout() {
        blackOutCurtain.size = CGSize(width: 2000, height: 2000)
        blackOutCurtain.color = UIColor.black
        blackOutCurtain.zPosition = 40
        
        self.addChild(blackOutCurtain)
    }
    
    var numberOfPlayerMoves = 0
    
    let zoomOutAction = SKAction.scale(to: 0.75, duration: 2)
    let zoomInAction = SKAction.scale(to: 0.5, duration: 2)
    
    let fadeOutAction = SKAction.fadeOut(withDuration: 2)
    func fadeOut() {
        blackOutCurtain.run(fadeInAction)
    }
    let fadeInAction = SKAction.fadeIn(withDuration: 2)
    func fadeIn() {
        blackOutCurtain.run(fadeOutAction)
    }
    
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
        
        fillEnemyArray()
        
        let walkUpFrames = [playerWalkUpOne, playerWalkUpOne, playerWalkUpTwo, playerWalkUpThree, playerWalkUpThree, playerWalkUpFour]
        let walkRightFrames = [playerWalkRightOne, playerWalkRightOne, playerWalkRightTwo, playerWalkRightThree, playerWalkRightThree, playerWalkRightFour]
        let walkLeftFrames = [playerWalkLeftOne, playerWalkLeftOne, playerWalkLeftTwo, playerWalkLeftThree, playerWalkLeftThree, playerWalkLeftFour]
        let walkDownFrames = [playerWalkDownOne, playerWalkDownOne, playerWalkDownTwo, playerWalkDownThree, playerWalkDownThree, playerWalkDownFour]
        
        walkUpAnimation = SKAction.animate(with: walkUpFrames, timePerFrame: 0.25)
        walkRightAnimation = SKAction.animate(with: walkRightFrames, timePerFrame: 0.25)
        walkDownAnimation = SKAction.animate(with: walkDownFrames, timePerFrame: 0.25)
        walkLeftAnimation = SKAction.animate(with: walkLeftFrames, timePerFrame: 0.25)
        
        overallControl()
        
        setupMap()
        updateCamera()
        animateDown()
        
        createBlackout()
        
        fadeIn()
        
        playerCamera.run(zoomInAction)
    }
    
    func spawnChest(spawnPoint: CGPoint) {
        
        //Chest
        let chest = SKSpriteNode()
        let chestTexture = SKTexture(imageNamed: "Chest")
        
        chest.texture = chestTexture
        chest.size = chestTexture.size()
        chest.zPosition = 15
        chest.lightingBitMask = 1
        
        chest.position = spawnPoint
        
        //Chest Light
        let chestLight = SKLightNode()
        chestLight.lightColor = UIColor.yellow
        chestLight.shadowColor = UIColor.clear
        chestLight.falloff = 3
        
        chest.addChild(chestLight)
        
        //Chest Emitter
        let chestEmitter = SKEmitterNode()
        let chestParticleTextureOne = SKTexture(imageNamed: "ChestParticleOne")
        let chestParticleTextureTwo = SKTexture(imageNamed: "ChestParticleTwo")
        let chestParticleTextureThree = SKTexture(imageNamed: "ChestParticleThree")
        let chestParticleTextureFour = SKTexture(imageNamed: "ChestParticleFour")
        let chestParticleFrames = [chestParticleTextureTwo, chestParticleTextureThree, chestParticleTextureFour, chestParticleTextureThree, chestParticleTextureTwo]
        let chestParticleAnimation = SKAction.animate(with: chestParticleFrames, timePerFrame: 0.1)
        
        chestEmitter.particleTexture = chestParticleTextureTwo
        chestEmitter.particleSize = chestParticleTextureOne.size()
        chestEmitter.particleAction = chestParticleAnimation
        chestEmitter.particleLifetime = 0.5
        chestEmitter.particlePositionRange = CGVector(dx: chest.size.width, dy: chest.size.width)
        chestEmitter.particleBirthRate = 1
        chestEmitter.zPosition = 16
        
        chest.addChild(chestEmitter)
        self.addChild(chest)
    }
    
    //Function for placing the map
    
    var tileTexture1 : SKTexture!
    var tileTexture2 : SKTexture!
    var tileTexture3 : SKTexture!
    var tileTexture4 : SKTexture!
    var tileTexture5 : SKTexture!
    
    var bgDefinition1 : SKTileDefinition!
    var bgDefinition2 : SKTileDefinition!
    var bgDefinition3 : SKTileDefinition!
    var bgDefinition4 : SKTileDefinition!
    var bgDefinition5 : SKTileDefinition!
    var bgDefinitionEnemy : SKTileDefinition!
    var bgDefinitionPlayer : SKTileDefinition!
    var bgDefinitionLoot : SKTileDefinition!
    
    var bgGroup1 : SKTileGroup!
    var bgGroup2 : SKTileGroup!
    var bgGroup3 : SKTileGroup!
    var bgGroup4 : SKTileGroup!
    var bgGroup5 : SKTileGroup!
    var bgGroupEnemy : SKTileGroup!
    var bgGroupPlayer : SKTileGroup!
    var bgGroupLoot : SKTileGroup!
    
    var tileSet : SKTileSet!
    
    func setupMap() {
        
        tileTexture1 = SKTexture(imageNamed: "Roof")
        tileTexture2 = SKTexture(imageNamed: "Wall")
        tileTexture3 = SKTexture(imageNamed: "Floor")
        tileTexture4 = SKTexture(imageNamed: "Staircase")
        tileTexture5 = SKTexture(imageNamed: "BlankTile")
        
        bgDefinition1 = SKTileDefinition(texture: tileTexture1, size: tileTexture1.size())
        bgGroup1 = SKTileGroup(tileDefinition: bgDefinition1)
        
        bgDefinition2 = SKTileDefinition(texture: tileTexture2, size: tileTexture2.size())
        bgGroup2 = SKTileGroup(tileDefinition: bgDefinition2)
        
        bgDefinition3 = SKTileDefinition(texture: tileTexture3, size: tileTexture3.size())
        bgGroup3 = SKTileGroup(tileDefinition: bgDefinition3)
        
        bgDefinition4 = SKTileDefinition(texture: tileTexture4, size: tileTexture4.size())
        bgGroup4 = SKTileGroup(tileDefinition: bgDefinition4)
        
        bgDefinition5 = SKTileDefinition(texture: tileTexture5, size: tileTexture5.size())
        bgGroup5 = SKTileGroup(tileDefinition: bgDefinition5)
        
        bgDefinitionEnemy = SKTileDefinition(texture: tileTexture3, size: tileTexture3.size())
        bgGroupEnemy = SKTileGroup(tileDefinition: bgDefinitionEnemy)
        
        bgDefinitionPlayer = SKTileDefinition(texture: tileTexture3, size: tileTexture3.size())
        bgGroupPlayer = SKTileGroup(tileDefinition: bgDefinitionPlayer)
        
        bgDefinitionLoot = SKTileDefinition(texture: tileTexture3, size: tileTexture3.size())
        bgGroupLoot = SKTileGroup(tileDefinition: bgDefinitionLoot)
        
        tileSet = SKTileSet(tileGroups: [bgGroup1, bgGroup2, bgGroup3, bgGroup4, bgGroup5, bgGroupEnemy, bgGroupPlayer, bgGroupLoot])
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
                    
                case 16:
                    
                    roomToPlace = allRooms.lootRoom
                    roomToPlaceRoof = allRooms.lootRoomRoof
                    
                case 17:
                    
                    roomToPlace = allRooms.stairRoom
                    roomToPlaceRoof = allRooms.stairRoomRoof
                    
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
                        case 4:
                            bgNode.setTileGroup(bgGroupLoot, forColumn: columnNo, row: rowNo)
                            spawnChest(spawnPoint: bgNode.centerOfTile(atColumn: columnNo, row: rowNo))
                        case 5:
                            bgNode.setTileGroup(bgGroup4, forColumn: columnNo, row: rowNo)
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
        
        player.texture = playerTexture
        player.size = playerTexture.size()
        player.zPosition = 20
        self.addChild(player)
        player.position = bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow)
        
        playerLight.lightColor = UIColor.orange
        playerLight.falloff = 1.5
        playerLight.categoryBitMask = 1
        playerLight.shadowColor = UIColor.clear
        player.addChild(playerLight)
        
        self.camera = playerCamera
        
        self.addChild(playerCamera)
        
    }
    
    
    
    //Floor z = 10
    //Player z = 20
    //Skull z = 35
    //Skull light z = 36
    //Roof z = 30
    //Sword z = 29
    
    
    
    
    //Enemy stuff
    
    let enemy1 = SKSpriteNode()
    var enemy1Column = 1
    var enemy1Row = 1
    
    let enemy2 = SKSpriteNode()
    var enemy2Column = 1
    var enemy2Row = 1
    
    let enemy3 = SKSpriteNode()
    var enemy3Column = 1
    var enemy3Row = 1
    
    let enemyTexture = SKTexture(imageNamed: "Ducko")
    
    var enemyArray = [SKSpriteNode]()
    var activeEnemyArray = [SKSpriteNode]()
    var enemyColumnArray = [Int]()
    var enemyRowArray = [Int]()
    
    var lineOfSightCheck = [Bool]()
    
    var randomEnemySpawnDirection : Int!
    var randomTileSpawn : Int!
    
    var enemyCounter = 0
    
    func fillEnemyArray() {
        enemyArray = [enemy1, enemy2, enemy3]
        enemyColumnArray = [enemy1Column, enemy2Column, enemy3Column]
        enemyRowArray = [enemy1Row, enemy2Row, enemy3Row]
        
        for enemy in enemyArray {
            
            enemy.texture = enemyTexture
            enemy.size = enemyTexture.size()
            enemy.lightingBitMask = 1
            enemy.zPosition = 25
            
        }
        
    }
    
    var columnChecker : Int!
    var rowChecker : Int!
    
    func findDistanceToPlayer(column: Int, row: Int) -> Int {
        
        if playerPositionColumn > column {
            columnChecker = playerPositionColumn - column
        } else {
            columnChecker = column - playerPositionColumn
        }
        
        if playerPositionRow > row {
            rowChecker = playerPositionRow - row
        } else {
            rowChecker = row - playerPositionRow
        }
        return(columnChecker + rowChecker)
    }
    
    var enemyMoveAction : SKAction!
    
    var bestDirectionArray = ["Empty","Empty","Empty","Empty"]
    
    func moveEnemy(_ enemyToMove: SKSpriteNode) {
        
        if bestDirectionArray.count > 0 {
            switch bestDirectionArray[0] {
                
            case "North":
                if bgNode.tileGroup(atColumn: northColumn, row: northRow) == bgGroup3 {
                    
                    enemyMoveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: northColumn, row: northRow), duration: 0.3)
                    
                    enemyToMove.run(enemyMoveAction)
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                    enemyColumnArray[enemyCounter] = northColumn
                    enemyRowArray[enemyCounter] = northRow
                    
                    bgNode.setTileGroup(bgGroupEnemy, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                } else if bgNode.tileGroup(atColumn: northColumn, row: northRow) == bgGroupPlayer {
                    
                    playerHealth -= 1
                    
                    gameViewController.updatePlayerLife(playerHealth)
                    
                    if playerHealth <= 0 {
                        gameOver()
                    }
                    
                } else {
                    bestDirectionArray.remove(at: 0)
                    moveEnemy(enemyToMove)
                }
                
            case "East":
                if bgNode.tileGroup(atColumn: eastColumn, row: eastRow) == bgGroup3 {
                    
                    enemyMoveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: eastColumn, row: eastRow), duration: 0.3)
                    
                    enemyToMove.run(enemyMoveAction)
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                    enemyColumnArray[enemyCounter] = eastColumn
                    enemyRowArray[enemyCounter] = eastRow
                    
                    bgNode.setTileGroup(bgGroupEnemy, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                } else if bgNode.tileGroup(atColumn: eastColumn, row: eastRow) == bgGroupPlayer {
                    
                    playerHealth -= 1
                    
                    gameViewController.updatePlayerLife(playerHealth)
                    
                    if playerHealth <= 0 {
                        gameOver()
                    }
                    
                } else {
                    bestDirectionArray.remove(at: 0)
                    moveEnemy(enemyToMove)
                }
                
            case "West":
                if bgNode.tileGroup(atColumn: westColumn, row: westRow) == bgGroup3 {
                    
                    enemyMoveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: westColumn, row: westRow), duration: 0.3)
                    
                    enemyToMove.run(enemyMoveAction)
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                    enemyColumnArray[enemyCounter] = westColumn
                    enemyRowArray[enemyCounter] = westRow
                    
                    bgNode.setTileGroup(bgGroupEnemy, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                } else if bgNode.tileGroup(atColumn: westColumn, row: westRow) == bgGroupPlayer {
                    
                    playerHealth -= 1
                    
                    gameViewController.updatePlayerLife(playerHealth)
                    
                    if playerHealth <= 0 {
                        gameOver()
                    }
                    
                } else {
                    bestDirectionArray.remove(at: 0)
                    moveEnemy(enemyToMove)
                }
                
            case "South":
                if bgNode.tileGroup(atColumn: southColumn, row: southRow) == bgGroup3 {
                    
                    enemyMoveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: southColumn, row: southRow), duration: 0.3)
                    
                    enemyToMove.run(enemyMoveAction)
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                    enemyColumnArray[enemyCounter] = southColumn
                    enemyRowArray[enemyCounter] = southRow
                    
                    bgNode.setTileGroup(bgGroupEnemy, forColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                    
                } else if bgNode.tileGroup(atColumn: southColumn, row: southRow) == bgGroupPlayer {
                    
                    playerHealth -= 1
                    
                    gameViewController.updatePlayerLife(playerHealth)
                    
                    if playerHealth <= 0 {
                        gameOver()
                    }
                } else {
                    bestDirectionArray.remove(at: 0)
                    moveEnemy(enemyToMove)
                }
            default:
                break
            }
        }
    }
    
    var northColumn : Int!
    var northRow : Int!
    
    var eastColumn : Int!
    var eastRow : Int!
    
    var southColumn : Int!
    var southRow : Int!
    
    var westColumn : Int!
    var westRow : Int!
    
    var northDistance : Int!
    var eastDistance : Int!
    var southDistance : Int!
    var westDistance : Int!
    
    var distanceArray = [Int]()
    
    var hasIncreasedAt0 = false
    var hasIncreasedAt5 = false
    var hasIncreasedAt10 = false
    var hasIncreasedAt15 = false
    var hasIncreasedAt20 = false
    
    var fillCounter = 0
    var emptyCounter = 0
    
    func fillBestDistance() {
        
        
        bestDirectionArray.insert("North", at: distanceArray.index(of: northDistance)!)
        
        bestDirectionArray.insert("East", at: distanceArray.index(of: eastDistance)!)
        
        bestDirectionArray.insert("South", at: distanceArray.index(of: southDistance)!)
        
        bestDirectionArray.insert("West", at: distanceArray.index(of: westDistance)!)
        
        emptyCounter = 0
        
        for i in bestDirectionArray {
            
            if i == "Empty" {
                bestDirectionArray.remove(at: emptyCounter)
            } else {
                emptyCounter += 1
            }
        }
    }
    
    func setupEnemies() {
        
        enemyCounter = 0
        
        if activeEnemyArray.count > 0 {
            for enemy in activeEnemyArray {
                
                distanceArray.removeAll()
                
                northColumn = enemyColumnArray[enemyCounter]
                northRow = enemyRowArray[enemyCounter] + 1
                northDistance = findDistanceToPlayer(column: northColumn, row: northRow)
                distanceArray.append(northDistance)
                
                
                eastColumn = enemyColumnArray[enemyCounter] + 1
                eastRow = enemyRowArray[enemyCounter]
                eastDistance = findDistanceToPlayer(column: eastColumn, row: eastRow)
                distanceArray.append(eastDistance)
                
                
                southColumn = enemyColumnArray[enemyCounter]
                southRow = enemyRowArray[enemyCounter] - 1
                southDistance = findDistanceToPlayer(column: southColumn, row: southRow)
                distanceArray.append(southDistance)
                
                
                westColumn = enemyColumnArray[enemyCounter] - 1
                westRow = enemyRowArray[enemyCounter]
                westDistance = findDistanceToPlayer(column: westColumn, row: westRow)
                distanceArray.append(westDistance)
                
                
                distanceArray.sort()
                
                bestDirectionArray = ["Empty","Empty","Empty","Empty"]
                
                fillCounter = 0
                
                fillBestDistance()
                
                
                moveEnemy(enemy)
                
                enemyCounter += 1
            }
        }
        
        if numberOfPlayerMoves % 5 == 0 {
            
            enemyCounter = 0
            
            for enemy in enemyArray {
                
                if activeEnemyArray.contains(enemy) == false {
                    
                    randomEnemySpawnDirection = Int(arc4random_uniform(3))
                    
                    switch randomEnemySpawnDirection {
                        
                    case 0:
                        randomTileSpawn = Int(arc4random_uniform(2))
                        
                        for i in 1...4 {
                            
                            if bgNode.tileGroup(atColumn: playerPositionColumn + (randomTileSpawn - 1), row: playerPositionRow + i) == bgGroup3 {
                                
                                lineOfSightCheck.append(true)
                                
                            } else {
                                
                                lineOfSightCheck.append(false)
                                
                            }
                            
                        }
                        
                        if lineOfSightCheck.contains(false) == false {
                            
                            enemyColumnArray[enemyCounter] = playerPositionColumn + (randomTileSpawn - 1)
                            
                            enemyRowArray[enemyCounter] = playerPositionRow + 4
                            
                            activeEnemyArray.append(enemy)
                            
                            sortActiveEnemyArray()
                            
                            self.addChild(enemy)
                            
                            enemy.position = bgNode.centerOfTile(atColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                            
                        }
                        
                        lineOfSightCheck.removeAll()
                        
                    case 1:
                        randomTileSpawn = Int(arc4random_uniform(2))
                        
                        for i in 1...4 {
                            
                            if bgNode.tileGroup(atColumn: playerPositionColumn + i, row: playerPositionRow + (randomTileSpawn - 1)) == bgGroup3 {
                                
                                lineOfSightCheck.append(true)
                                
                            } else {
                                
                                lineOfSightCheck.append(false)
                                
                            }
                            
                        }
                        
                        if lineOfSightCheck.contains(false) == false {
                            
                            enemyColumnArray[enemyCounter] = playerPositionColumn + 4
                            
                            enemyRowArray[enemyCounter] = playerPositionRow + (randomTileSpawn - 1)
                            
                            activeEnemyArray.append(enemy)
                            
                            sortActiveEnemyArray()
                            
                            self.addChild(enemy)
                            
                            enemy.position = bgNode.centerOfTile(atColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                            
                        }
                        
                        lineOfSightCheck.removeAll()
                        
                    case 2:
                        randomTileSpawn = Int(arc4random_uniform(2))
                        
                        for i in 1...4 {
                            
                            if bgNode.tileGroup(atColumn: playerPositionColumn + (randomTileSpawn - 1), row: playerPositionRow - i) == bgGroup3 {
                                
                                lineOfSightCheck.append(true)
                                
                            } else {
                                
                                lineOfSightCheck.append(false)
                                
                            }
                            
                        }
                        
                        if lineOfSightCheck.contains(false) == false {
                            
                            enemyColumnArray[enemyCounter] = playerPositionColumn + (randomTileSpawn - 1)
                            
                            enemyRowArray[enemyCounter] = playerPositionRow - 4
                            
                            activeEnemyArray.append(enemy)
                            
                            sortActiveEnemyArray()
                            
                            self.addChild(enemy)
                            
                            enemy.position = bgNode.centerOfTile(atColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                            
                        }
                        
                        lineOfSightCheck.removeAll()
                        
                    case 3:
                        randomTileSpawn = Int(arc4random_uniform(2))
                        
                        for i in 1...4 {
                            
                            if bgNode.tileGroup(atColumn: playerPositionColumn - i, row: playerPositionRow + (randomTileSpawn - 1)) == bgGroup3 {
                                lineOfSightCheck.append(true)
                            } else {
                                lineOfSightCheck.append(false)
                            }
                        }
                        
                        if lineOfSightCheck.contains(false) == false {
                            
                            enemyColumnArray[enemyCounter] = playerPositionColumn - 4
                            
                            enemyRowArray[enemyCounter] = playerPositionRow + (randomTileSpawn - 1)
                            
                            activeEnemyArray.append(enemy)
                            
                            sortActiveEnemyArray()
                            
                            self.addChild(enemy)
                            
                            enemy.position = bgNode.centerOfTile(atColumn: enemyColumnArray[enemyCounter], row: enemyRowArray[enemyCounter])
                        }
                        lineOfSightCheck.removeAll()
                    
                    default:
                        break
                    }
                }
                enemyCounter += 1
            }
        }
    }
    
    func sortActiveEnemyArray() {
        
        if activeEnemyArray.contains(enemy1) == true && activeEnemyArray.contains(enemy2) == true && activeEnemyArray.contains(enemy3) == false {
            activeEnemyArray = [enemy1, enemy2]
        } else if activeEnemyArray.contains(enemy1) == false && activeEnemyArray.contains(enemy2) == true && activeEnemyArray.contains(enemy3) == true {
            activeEnemyArray = [enemy2, enemy3]
        } else if activeEnemyArray.contains(enemy1) == true && activeEnemyArray.contains(enemy2) == false && activeEnemyArray.contains(enemy3) == true {
            activeEnemyArray = [enemy1, enemy3]
        } else if activeEnemyArray.contains(enemy1) == true && activeEnemyArray.contains(enemy2) == true && activeEnemyArray.contains(enemy3) == true {
            activeEnemyArray = [enemy1, enemy2, enemy3]
        }
    }
    
    //Function for the player moving
    func playerMove(label: String) {
        
        if isMoving == false {
            
            numberOfPlayerMoves += 1
            
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
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionRow += 1
                    
                    bgNode.setTileGroup(bgGroupPlayer, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        self.isMoving = false
                    }
                    player.run(moveAction)
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow + 1) == bgGroup4 {
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionRow += 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    player.run(moveAction)
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        if self.facingDown != true {
                            
                            self.facingUp = false
                            self.facingRight = false
                            self.facingDown = true
                            self.facingLeft = false
                            
                            self.animateDown()
                        }
                        self.playerCamera.run(self.zoomOutAction)
                        self.fadeOut()
                        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            self.regenerate()
                        }
                    }
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow + 1) == bgGroupLoot {
                    
                    if playerHealth < 5 {
                        
                        playerHealth += 1
                        gameViewController.updatePlayerLife(playerHealth)
                    }
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
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionColumn += 1
                    
                    bgNode.setTileGroup(bgGroupPlayer, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        self.isMoving = false
                    }
                    player.run(moveAction)
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn + 1, row: playerPositionRow) == bgGroup4 {
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionColumn += 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    player.run(moveAction)
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        if self.facingDown != true {
                            
                            self.facingUp = false
                            self.facingRight = false
                            self.facingDown = true
                            self.facingLeft = false
                            
                            self.animateDown()
                        }
                        self.playerCamera.run(self.zoomOutAction)
                        self.fadeOut()
                        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            self.regenerate()
                        }
                    }
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn + 1, row: playerPositionRow) == bgGroupLoot {
                    
                    if playerHealth < 5 {
                        playerHealth += 1
                        gameViewController.updatePlayerLife(playerHealth)
                    }
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
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionRow -= 1
                    
                    bgNode.setTileGroup(bgGroupPlayer, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        self.isMoving = false
                    }
                    player.run(moveAction)
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow - 1) == bgGroup4 {
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionRow -= 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    player.run(moveAction)
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        if self.facingDown != true {
                            
                            self.facingUp = false
                            self.facingRight = false
                            self.facingDown = true
                            self.facingLeft = false
                            
                            self.animateDown()
                        }
                        self.playerCamera.run(self.zoomOutAction)
                        self.fadeOut()
                        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            self.regenerate()
                        }
                    }
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow - 1) == bgGroupLoot {
                    
                    if playerHealth < 5 {
                        playerHealth += 1
                        
                        gameViewController.updatePlayerLife(playerHealth)
                    }
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
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionColumn -= 1
                    
                    bgNode.setTileGroup(bgGroupPlayer, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        self.isMoving = false
                    }
                    player.run(moveAction)
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn - 1, row: playerPositionRow) == bgGroup4 {
                    
                    bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow)
                    
                    playerPositionColumn -= 1
                    
                    moveAction = SKAction.move(to: bgNode.centerOfTile(atColumn: playerPositionColumn, row: playerPositionRow), duration: 0.3)
                    
                    isMoving = true
                    
                    player.run(moveAction)
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                        if self.facingDown != true {
                            
                            self.facingUp = false
                            self.facingRight = false
                            self.facingDown = true
                            self.facingLeft = false
                            
                            self.animateDown()
                        }
                        self.playerCamera.run(self.zoomOutAction)
                        self.fadeOut()
                        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            self.regenerate()
                        }
                    }
                    
                } else if bgNode.tileGroup(atColumn: playerPositionColumn - 1, row: playerPositionRow) == bgGroupLoot {
                    
                    if playerHealth < 5 {
                        
                        playerHealth += 1
                        
                        gameViewController.updatePlayerLife(playerHealth)
                    }
                }
            default:
                break
            }
            setupEnemies()
        }
    }
    
    //Function for the player attacking
    
    var attackCheckColumn : Int!
    var attackCheckRow : Int!
    var enemyRemoveIndex = 0
    var enemyRemoved = false
    
    func playerAttack(attackDirection: String) {
        
        let attackSprite = SKSpriteNode()
        
        attackSprite.size = CGSize(width: (SKTexture(imageNamed: "SwordSwipeOne").size().width / 3) * 2, height: (SKTexture(imageNamed: "SwordSwipeOne").size().height / 3) * 2)
        attackSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        attackSprite.zPosition = 29
        attackSprite.lightingBitMask = 1
        
        //Frames for the sword swipe animation
        let swipeOne = SKTexture(imageNamed: "SwordSwipeOne")
        let swipeTwo = SKTexture(imageNamed: "SwordSwipeTwo")
        let swipeThree = SKTexture(imageNamed: "SwordSwipeThree")
        let swipeFour = SKTexture(imageNamed: "SwordSwipeFour")
        let swipeFive = SKTexture(imageNamed: "SwordSwipeFive")
        
        let attackFrames = [swipeOne, swipeTwo, swipeThree, swipeFour, swipeFive]
        
        let attackAnimation = SKAction.animate(with: attackFrames, timePerFrame: 0.05)
        
        numberOfPlayerMoves += 1
        
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
            
            //Kill an enemy if it's in the way of the attack
            if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow + 1) == bgGroupEnemy {
                
                enemyRemoved = false
                
                for i in 1...activeEnemyArray.count {
                    if enemyRemoved == false {
                        if enemyColumnArray[i-1] == playerPositionColumn && enemyRowArray[i-1] == playerPositionRow + 1 {
                            
                            enemyRemoveIndex = i-1
                            
                            activeEnemyArray[enemyRemoveIndex].removeFromParent()
                            activeEnemyArray.remove(at: enemyRemoveIndex)
                            
                            overallScore += 25
                            gameViewController.updateOverallScore(overallScore)
                            
                            bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow + 1)
                            enemyRemoved = true
                            
                            sortActiveEnemyArray()
                        }
                        
                    }
                    
                }
                
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
            
            if bgNode.tileGroup(atColumn: playerPositionColumn + 1, row: playerPositionRow) == bgGroupEnemy {
                
                enemyRemoved = false
                
                for i in 1...activeEnemyArray.count {
                    if enemyRemoved == false {
                        if enemyColumnArray[i-1] == playerPositionColumn + 1 && enemyRowArray[i-1] == playerPositionRow {
                            
                            enemyRemoveIndex = i-1
                            
                            activeEnemyArray[enemyRemoveIndex].removeFromParent()
                            activeEnemyArray.remove(at: enemyRemoveIndex)
                            
                            overallScore += 25
                            gameViewController.updateOverallScore(overallScore)
                            
                            bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn + 1, row: playerPositionRow)
                            enemyRemoved = true
                            
                            sortActiveEnemyArray()
                        }
                        
                    }
                    
                }
                
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
            
            if bgNode.tileGroup(atColumn: playerPositionColumn, row: playerPositionRow - 1) == bgGroupEnemy {
                
                enemyRemoved = false
                
                for i in 1...activeEnemyArray.count {
                    if enemyRemoved == false {
                        
                        if enemyColumnArray[i-1] == playerPositionColumn && enemyRowArray[i-1] == playerPositionRow - 1 {
                            
                            enemyRemoveIndex = i-1
                            
                            activeEnemyArray[enemyRemoveIndex].removeFromParent()
                            activeEnemyArray.remove(at: enemyRemoveIndex)
                            
                            overallScore += 25
                            gameViewController.updateOverallScore(overallScore)
                            
                            bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn, row: playerPositionRow - 1)
                            enemyRemoved = true
                            
                            sortActiveEnemyArray()
                        }
                        
                    }
                    
                }
                
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
            
            if bgNode.tileGroup(atColumn: playerPositionColumn - 1, row: playerPositionRow) == bgGroupEnemy {
                
                enemyRemoved = false
                
                for i in 1...activeEnemyArray.count {
                    if enemyRemoved == false {
                        if enemyColumnArray[i-1] == playerPositionColumn - 1 && enemyRowArray[i-1] == playerPositionRow {
                            
                            enemyRemoveIndex = i-1
                            
                            activeEnemyArray[enemyRemoveIndex].removeFromParent()
                            activeEnemyArray.remove(at: enemyRemoveIndex)
                            
                            overallScore += 25
                            gameViewController.updateOverallScore(overallScore)
                            
                            bgNode.setTileGroup(bgGroup3, forColumn: playerPositionColumn - 1, row: playerPositionRow)
                            enemyRemoved = true
                            
                            sortActiveEnemyArray()
                        }
                        
                    }
                    
                }
                
            }
            
        default:
            break
        }
        
        setupEnemies()
    }
    
    // Room regeneration
    
    func regenerate() {
        
        // Increases the score by 100 for going up one level
        overallScore += 100
        gameViewController.updateOverallScore(overallScore)
        
        self.removeAllChildren()
        player.removeAllChildren()
        
        floor = [
            [0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0]
        ]
        
        currentFloor += 1
        playerPositionColumn = 24
        playerPositionRow = 24
        numberOfPlayerMoves = 0
        
        activeEnemyArray.removeAll()
        
        columnNo = 0
        rowNo = 48
        
        roofColumnNo = 0
        roofRowNo = 48
        
        overallControl()
        setupMap()
        updateCamera()
        animateDown()
        
        //self.run(fadeInAction)
        playerCamera.run(zoomInAction)
        
        createBlackout()
        fadeIn()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.isMoving = false
        }
    }
    
    // when game ends
    func gameOver() {
        // overallScore
        
        let LEADERBOARD_ID = "BS"
        
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(overallScore)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                //print(error!.localizedDescription)
            } else {
                //print("Best Score submitted to your Leaderboard!")
            }
        }
        
        gameViewController.highScore(overallScore)
        
        playerPositionColumn = 24
        playerPositionRow = 24
        numberOfPlayerMoves = 0
        
        activeEnemyArray.removeAll()
        
        columnNo = 0
        rowNo = 48
        
        roofColumnNo = 0
        roofRowNo = 48
        
        gameViewController.performSegue(withIdentifier: "titleSegue", sender: self)
        
    }
    
    //Functions for making the camera follow the player
    
    func updateCamera() {
        if let playerCamera = camera {
            playerCamera.position = CGPoint(x: player.position.x, y: player.position.y)
        }
    }
    
    //Update the camera every frame
    override func update(_ currentTime: TimeInterval) {
        updateCamera()
    }
}
