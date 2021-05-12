//
//  BoardViewModel.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-06.
//

import SwiftUI

final class BoardViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var boardDisabled = false
    @Published var alertItem: AlertItem?
    
    //game settings
    @AppStorage("aiCompetitor") var competitorAI: Bool = true
    @AppStorage("aiDifficulty") var aiDifficulty: Int = 1
    private var turn: Player = .human1
    private var initialTurn: Player?
    
    func processPlayerMove(for position: Int) {
        
        if isOccupied(in: moves, forIndex: position) { return }
        
        if turn == .human1 {
            withAnimation(Animation.easeIn(duration: 0.4)) {
                moves[position] = Move(player: turn, boardIndex: position)
            }
            
            if checkWin(for: turn, in: moves) {
                if competitorAI {
                    alertItem = AlertContext.humanWin
                } else {
                    alertItem = AlertContext.human1Win
                }
                return
            }
            if checkForDraw(in: moves) {
                turn = initialTurn ?? .human1
                alertItem = AlertContext.draw
                return
            }
            //disable board after the move so AI could make one and change the turn
            if competitorAI{
                boardDisabled = true
                turn = .ai
            } else {
                turn = .human2
            }

        } else {
            if !competitorAI {
                withAnimation(Animation.easeIn(duration: 0.4)) {
                    moves[position] = Move(player: turn, boardIndex: position)
                }
                if checkWin(for: turn, in: moves) {
                    alertItem = AlertContext.human2Win
                    return
                }

                if checkForDraw(in: moves) {
                    turn = initialTurn ?? .human1
                    alertItem = AlertContext.draw
                    return
                }
                turn = .human1
            }
        }
        
        if turn == .ai {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
                let computerPosition = computerMovePosition(in: moves, difficulty: aiDifficulty)
                withAnimation(Animation.easeIn(duration: 0.4)) {
                    moves[computerPosition] = Move(player: turn, boardIndex: computerPosition)
                }
                if checkWin(for: turn, in: moves) {
                    alertItem = AlertContext.aiWin
                    return
                }
                if checkForDraw(in: moves) {
                    turn = initialTurn ?? .human1
                    alertItem = AlertContext.draw
                    return
                }
                boardDisabled = false
                turn = .human1
                return
            }
        }
    }

    func resetGame(){
        initialTurn = turn
        withAnimation(Animation.easeOut(duration: 0.5)) {
            moves = Array(repeating: nil, count: 9)
        }
        boardDisabled = false
        if turn == .ai {
            boardDisabled = true
            processPlayerMove(for: 0)
        }
    }
    
    func isOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    var uselessPositions: Set<Int> = []
    
    func generateRandomMove() -> Int {
        var randomMovePosition = Int.random(in: 0..<9)
        if uselessPositions.count != 0 {
            //make sure to not generate not a winning move for strong AI difficulty
            while isOccupied(in: moves, forIndex: randomMovePosition) || uselessPositions.contains(randomMovePosition) {
                randomMovePosition = Int.random(in: 0..<9)
            }
        } else {
            while isOccupied(in: moves, forIndex: randomMovePosition) {
                randomMovePosition = Int.random(in: 0..<9)
            }
        }
        uselessPositions.removeAll()
        return randomMovePosition
    }
    
    func computerMovePosition(in moves: [Move?], difficulty: Int) -> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]]
        
        let aiMoves = moves.compactMap { $0 }.filter({$0.player == .ai})
        let aiPositions = Set(aiMoves.map({$0.boardIndex}))
        
        let playerMoves = moves.compactMap { $0 }.filter({$0.player == .human1})
        let playerPositions = Set(playerMoves.map({$0.boardIndex}))
        
        let centerPosition = 4
        
        uselessPositions.removeAll()
        //logic for easy ai
        if difficulty == 0 {
            //check for win move
            for patternForWin in winPatterns {
                let winPositions = patternForWin.subtracting(aiPositions)
                if winPositions.count == 1 {
                    let isAvailable = !isOccupied(in: moves, forIndex: winPositions.first!)
                    if isAvailable {
                        print("Win Move")
                        return winPositions.first!
                    } else {
                        print("Random Move")
                        return generateRandomMove()
                    }
                } else { continue }
            }
        }
        //logic for medium ai
        if difficulty == 1 {
            //check for block move
            for patternForBlock in winPatterns {
                let blockPositions = patternForBlock.subtracting(playerPositions)
                if blockPositions.count == 1 {
                    let isAvailable = !isOccupied(in: moves, forIndex: blockPositions.first!)
                    if isAvailable {
                        print("Block Move")
                        return blockPositions.first!
                    } else {
                        //check for win move
                        for patternForWin in winPatterns {
                            let winPositions = patternForWin.subtracting(aiPositions)
                            
                            if winPositions.count == 1 {
                                let isAvailable = !isOccupied(in: moves, forIndex: winPositions.first!)
                                if isAvailable {
                                    return winPositions.first!
                                } else {
                                    print("Random Move")
                                    return generateRandomMove()
                                }
                            } else { continue }
                        }
                    }
                } else { continue }
            }
        }
        //logic for strong ai
        if difficulty == 2 {
            var blockPosition: Int?
            var winPosition: Int?
            
            //secure center if is not occupied
            if !isOccupied(in: moves, forIndex: centerPosition) {
                print("Center Move")
                return centerPosition
            } else {
                //if center is occupate, secure corner cell so the human could not win. only draw
                if moves.compactMap({ $0 }).count == 1 {
                    uselessPositions.insert(1)
                    uselessPositions.insert(3)
                    uselessPositions.insert(5)
                    uselessPositions.insert(7)
                    print("Secure move")
                    return generateRandomMove()
                }
                //check for block
                outerLoop: for patternForBlock in winPatterns {
                    let blockPositions = patternForBlock.subtracting(playerPositions)
                    if blockPositions.count == 1 {
                        let isAvailable = !isOccupied(in: moves, forIndex: blockPositions.first!)
                        if isAvailable {
                            blockPosition = blockPositions.first!
                            continue
                        } else {
                            //check for win
                            innerLoop: for patternForWin in winPatterns {
                                let winPositions = patternForWin.subtracting(aiPositions)
                                
                                if winPositions.count == 1 {
                                    let isAvailable = !isOccupied(in: moves, forIndex: winPositions.first!)
                                    if isAvailable {
                                        winPosition = winPositions.first!
                                        break outerLoop
                                    } else { continue }
                                } else { continue }
                            }
                        }
                    } else { continue }
                }
            }
            //decide what move to go
            if blockPosition == nil && winPosition == nil {
                //check if there is a not winning move by checking the win pattern on having two moves of different players and store it to avoid for random move
                for patternForStrong in winPatterns {
                    let playerPositionsInPattern = patternForStrong.subtracting(playerPositions)
                    let aIPositionsInPattern = patternForStrong.subtracting(aiPositions)
                    if playerPositionsInPattern.count == 2 && aIPositionsInPattern.count == 2 {
                        //the condition relevent only at the second ai's move so check the moves count
                        if moves.compactMap({ $0 }).count > 2 && moves.compactMap({ $0 }).count < 5 {
                            uselessPositions.insert(playerPositionsInPattern.intersection(aIPositionsInPattern).first!)
                        }
                    } else { continue }
                }
                print("Random Move")
                return generateRandomMove()
            } else if blockPosition == nil && winPosition != nil {
                print("Win Move")
                return winPosition!
            } else if blockPosition != nil && winPosition == nil {
                print("Block Move")
                return blockPosition!
            } else if blockPosition != nil && winPosition != nil {
                print("Win Move")
                //if AI can block and win - Win
                return winPosition!
            }
        }
        print("Random Move")
        return generateRandomMove()
    }
    
    func checkWin(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]]
        let playerMoves = moves.compactMap { $0 }.filter({$0.player == player})
        let playerPositions = Set(playerMoves.map({$0.boardIndex}))
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
}
