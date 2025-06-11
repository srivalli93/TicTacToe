//
//  GameViewModel.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 6/10/25.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    func isSpaceAvailable(_ index: Int) -> Bool {
        return moves[index] == nil
    }
    
    //basic computer moves
    func determineComputerMovePosition() -> Int {
        
        // If AI can win, take the win
        let winningCombinations: Set<Set<Int>> = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map {$0.boardIndex })
        
        for pattern in winningCombinations {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
               let isAvailable = isSpaceAvailable(winPositions.first!)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        // If AI can't win, block
        
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map {$0.boardIndex })
        
        for pattern in winningCombinations {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
               let isAvailable = isSpaceAvailable(winPositions.first!)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        // If AI can't block, take the middle square
        
        let centerSquareIndex: Int = 4
        if isSpaceAvailable(centerSquareIndex) {
            return centerSquareIndex
        }
        // If AI can't take middle square, take random square
        
        var movePosition: Int = Int.random(in: 0..<9)
        
        while !isSpaceAvailable(movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
        
    }
    
    func checkWinPositions(for player: Player) -> Bool {
        
        let winningCombinations: Set<Set<Int>> = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map {$0.boardIndex })
        
        for pattern in winningCombinations where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func checkForDraw() -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetBoard() {
        moves = Array(repeating: nil, count: 9)
        isBoardDisabled = false
    }
    
    func processPlayerMove(at index: Int) {
        //game logic
        
        //check if the space is available
        if isSpaceAvailable(index) {
            moves[index] = Move(player: .human, boardIndex: index)
            
            if checkWinPositions(for: .human) {
                alertItem = AlertContent.humanWin
                return
            }
            if checkForDraw() {
                alertItem = AlertContent.draw
                return
            }
            isBoardDisabled = true
            
        } else {
            return
        }
        
        //after human move. Check for win condition or draw
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerMove = determineComputerMovePosition()
            moves[computerMove] = Move(player: .computer, boardIndex: computerMove)
            
            if checkWinPositions(for: .computer) {
                alertItem = AlertContent.computerWin
                return
            }
            if checkForDraw() {
                alertItem = AlertContent.draw
                return
            }
            isBoardDisabled = false
        }
    }
    
}
