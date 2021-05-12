//
//  Structs.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-09.
//

import Foundation

enum Player {
    case human1, human2, ai
}

enum Competitor {
    case human, ai
}

enum Difficulty {
    case easy, medium, hard
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human1 ? "xmark" : "circle"
    }
}
