//
//  TicTacToeBoardView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 7/14/25.
//

import SwiftUI

struct TicTacToeBoardView: View {
    @ObservedObject var vm: GameViewModel
    
    // Highlight winning cells if any
    private var winningIndices: [Int] {
        guard let winner = vm.winner else { return [] }
        let wins: Set<Set<Int>> = [
            [0,1,2],[3,4,5],[6,7,8],
            [0,3,6],[1,4,7],[2,5,8],
            [0,4,8],[2,4,6]
        ]
        let playerMoves = Set(vm.board.indices.filter { vm.board[$0] == winner })
        return wins.first(where: { $0.isSubset(of: playerMoves) })?.map { $0 } ?? []
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width / 3 - 16
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(size), spacing: 8), count: 3), spacing: 8) {
                ForEach(0..<9) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .shadow(color: winningIndices.contains(index) ? .green.opacity(0.6) : .black.opacity(0.15), radius: 6, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(winningIndices.contains(index) ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                            )

                        if let player = vm.board[index] {
                            Image(systemName: player.rawValue)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(player == .x ? .red : .blue)
                                .padding(20)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.easeInOut(duration: 0.3), value: vm.board[index])
                        }
                    }
                    .frame(width: size, height: size)
                    .onTapGesture {
                        withAnimation {
                            vm.makeMove(at: index)
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}
