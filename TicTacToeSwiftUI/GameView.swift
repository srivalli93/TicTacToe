//
//  GameView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 5/15/25.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var gameManager = GameViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: gameManager.columns, spacing: 10) {
                    ForEach(0..<9) { index in
                        ZStack {
                            //game UI
                            GameSquareView(proxy: geometry)
                            
                            PlayerIndicator(sytsemImageName: gameManager.moves[index]?.indicator ?? "")
                        }
                        .onTapGesture {
                            gameManager.processPlayerMove(at: index)
                        }
                    }
                }
                .background(Color.black)
                Spacer()
            }
            .padding()
            .disabled(gameManager.isBoardDisabled)
            .alert(item: $gameManager.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    gameManager.resetBoard()
                }))
            }
        }
    }
}

enum Player {
    case human
    case computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator : String {
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    GameView()
}

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        let size = (min(proxy.size.width, proxy.size.height) / 3) - 15
        Rectangle()
            .foregroundColor(.white)
            .frame(width: size, height: size)
    }
}

struct PlayerIndicator: View {
    var sytsemImageName: String
    var body: some View {
        Image(systemName: sytsemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.blue)
    }
}
