//
//  ContentView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 5/15/25.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn: Bool = true
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0..<9) { index in
                        ZStack {
                            //game UI
                            Rectangle()
                                .foregroundStyle(.white)
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                            
                            Image(systemName: moves[index]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                        }
                        .onTapGesture {
                            //game logic
                            
                            //check if the space is available
                            if isSpaceAvailable(index) {
                                moves[index] = Move(player: isHumanTurn ? .human : .computer, boardIndex: index)
                                isHumanTurn.toggle()
                            }
                        }
                    }
                    
                }
                .background(Color.black)
                Spacer()
            }
            .padding()
        }
    }
    
    func isSpaceAvailable(_ index: Int) -> Bool {
        return moves[index] == nil
    }
    
    //basic computer moves
    func determineComputerMovePosition() -> Int {
        var movePosition: Int = Int.random(in: 0..<9)
        
        while !isSpaceAvailable(movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
        
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
    ContentView()
}
