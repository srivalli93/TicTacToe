//
//  GameView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 5/15/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Scoreboard
                HStack(spacing: 40) {
                    VStack {
                        Text("X")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text("\(vm.scores.x)")
                            .font(.title)
                            .bold()
                    }
                    VStack {
                        Text("Draw")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(vm.scores.draw)")
                            .font(.title)
                            .bold()
                    }
                    VStack {
                        Text("O")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text("\(vm.scores.o)")
                            .font(.title)
                            .bold()
                    }
                }

                // Turn indicator or winner/draw message
                if let winner = vm.winner {
                    Text("\(winner == .x ? "X" : "O") Wins! 🎉")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(winner == .x ? .red : .blue)
                } else if vm.isDraw {
                    Text("It's a Draw!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                } else {
                    Text("Turn: \(vm.turn == .x ? "X" : "O")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(vm.turn == .x ? .red : .blue)
                }

                // Game board
                TicTacToeBoardView(vm: vm)
                    .frame(maxWidth: 400, maxHeight: 400)

                // Reset button
                Button("Reset Game") {
                    vm.resetBoard()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                Spacer()
            }
            .padding()
            .navigationTitle("Tic Tac Toe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(showSheet: $showingSettings, vm: vm)
            }
        }
    }
}
#Preview {
    GameView()
}
