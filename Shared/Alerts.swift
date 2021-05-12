//
//  Alerts.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-06.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var text: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"), text: Text("Nice one, dude!"), buttonTitle: Text("Yeah!"))
    static let human1Win = AlertItem(title: Text("Player 1 wins!"), text: Text("Try to beat him next time"), buttonTitle: Text("Oh, I will..."))
    static let human2Win = AlertItem(title: Text("Player 2 wins!"), text: Text("Try to beat him in the next game"), buttonTitle: Text("Oh, I will..."))
    static let aiWin = AlertItem(title: Text("You Lost!"), text: Text("This AI is a monster"), buttonTitle: Text("Damn..."))
    static let draw = AlertItem(title: Text("Draw!"), text: Text("What a game..."), buttonTitle: Text("Try Again"))
}
