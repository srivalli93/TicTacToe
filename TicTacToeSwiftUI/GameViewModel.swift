//
//  GameViewModel.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 6/10/25.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    // MARK: - Types

    enum Player: String, Hashable {
        case x = "xmark"
        case o = "circle"

        var toggled: Player { self == .x ? .o : .x }
    }

    enum Opponent: Hashable {
        case human
        case computer(easy: Bool)
    }

    // MARK: - Published Properties

    @Published private(set) var board: [Player?] = Array(repeating: nil, count: 9)
    @Published private(set) var turn: Player
    @Published private(set) var winner: Player? = nil
    @Published private(set) var isDraw = false
    @Published var opponent: Opponent = .human

    // MARK: - Persistent Scores

    @AppStorage("scoreX") private var scoreX = 0
    @AppStorage("scoreO") private var scoreO = 0
    @AppStorage("scoreDraw") private var scoreDraw = 0

    var scores: (x: Int, o: Int, draw: Int) {
        (scoreX, scoreO, scoreDraw)
    }

    // MARK: - Private

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(firstPlayer: Player = .x) {
        self.turn = firstPlayer

        $winner
            .sink { [weak self] winner in
                guard let self = self else { return }
                if let winner = winner {
                    self.incrementScore(for: winner)
                } else if self.isDraw {
                    self.scoreDraw += 1
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    func makeMove(at index: Int) {
        guard board.indices.contains(index),
              board[index] == nil,
              winner == nil else { return }

        board[index] = turn

        if checkWin(for: turn) {
            winner = turn
        } else if !board.contains(where: { $0 == nil }) {
            isDraw = true
        } else {
            turn = turn.toggled
            triggerAIMoveIfNeeded()
        }
    }

    func resetBoard(firstPlayer: Player? = nil) {
        board = Array(repeating: nil, count: 9)
        winner = nil
        isDraw = false
        if let firstPlayer = firstPlayer {
            turn = firstPlayer
        }
    }

    func resetScores() {
        scoreX = 0
        scoreO = 0
        scoreDraw = 0
    }
}

// MARK: - Private Helpers

private extension GameViewModel {
    func incrementScore(for player: Player) {
        switch player {
        case .x: scoreX += 1
        case .o: scoreO += 1
        }
    }

    func triggerAIMoveIfNeeded() {
        guard case .computer = opponent,
              turn == .o,
              winner == nil,
              !isDraw else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let move: Int
            switch self.opponent {
            case .computer(let easy):
                move = easy ? self.randomMove() : self.computerMove()
            default:
                return
            }
            self.makeMove(at: move)
        }
    }

    func checkWin(for player: Player) -> Bool {
        let winningCombinations: Set<Set<Int>> = [
            [0,1,2],[3,4,5],[6,7,8], // rows
            [0,3,6],[1,4,7],[2,5,8], // columns
            [0,4,8],[2,4,6]          // diagonals
        ]
        let playerMoves = Set(board.indices.filter { board[$0] == player })
        return winningCombinations.contains { $0.isSubset(of: playerMoves) }
    }
}

// MARK: - AI Logic (Sean Allen style)

private extension GameViewModel {
    func computerMove() -> Int {
        let winPatterns = winningPatterns()

        // 1. Win if possible
        if let win = findWinningMove(for: .o, patterns: winPatterns) {
            return win
        }

        // 2. Block opponent's winning move
        if let block = findWinningMove(for: .x, patterns: winPatterns) {
            return block
        }

        // 3. Take center
        if board[4] == nil {
            return 4
        }

        // 4. Take any corner
        let corners = [0, 2, 6, 8]
        if let corner = corners.first(where: { board[$0] == nil }) {
            return corner
        }

        // 5. Take any side
        let sides = [1, 3, 5, 7]
        if let side = sides.first(where: { board[$0] == nil }) {
            return side
        }

        // Fallback (should never happen)
        return board.firstIndex(where: { $0 == nil }) ?? 0
    }

    func randomMove() -> Int {
        board.indices.filter { board[$0] == nil }.randomElement() ?? 0
    }

    func winningPatterns() -> [[Int]] {
        [
            [0,1,2],[3,4,5],[6,7,8],  // rows
            [0,3,6],[1,4,7],[2,5,8],  // columns
            [0,4,8],[2,4,6]           // diagonals
        ]
    }

    func findWinningMove(for player: Player, patterns: [[Int]]) -> Int? {
        for pattern in patterns {
            let marks = pattern.map { board[$0] }
            let playerCount = marks.filter { $0 == player }.count
            let emptyCount = marks.filter { $0 == nil }.count

            if playerCount == 2 && emptyCount == 1,
               let emptyIndex = marks.firstIndex(of: nil) {
                return pattern[emptyIndex]
            }
        }
        return nil
    }
}

