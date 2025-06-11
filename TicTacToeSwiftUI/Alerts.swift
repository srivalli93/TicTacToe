//
//  Alerts.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 6/10/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContent {
    static let humanWin = AlertItem(title: Text("Human Wins!"), message: Text("You are so smart, you beat your own AI!!!!"), buttonTitle: Text("Play Again"))
    static let computerWin = AlertItem(title: Text("Computer Wins!"), message: Text("You couldnt beat your own AI!!!! You programmed a super AI"), buttonTitle: Text("Play Again"))
    static let draw = AlertItem(title: Text("Draw!"), message: Text("What a battle!! Lets have a rematch"), buttonTitle: Text("Play Again"))
}
