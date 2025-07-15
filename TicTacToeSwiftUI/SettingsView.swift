//
//  SettingsView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 7/14/25.
//


import SwiftUI

struct SettingsView: View {
    @Binding var showSheet: Bool
    @ObservedObject var vm: GameViewModel

    @AppStorage("firstPlayer") private var firstRawValue = GameViewModel.Player.x.rawValue

    private var firstPlayer: GameViewModel.Player {
        get { GameViewModel.Player(rawValue: firstRawValue) ?? .x }
        set { firstRawValue = newValue.rawValue }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Game Mode") {
                    Picker("Opponent", selection: $vm.opponent) {
                        Text("Human vs Human").tag(GameViewModel.Opponent.human)
                        Text("Human vs Computer (Easy)").tag(GameViewModel.Opponent.computer(easy: true))
                        Text("Human vs Computer (Hard)").tag(GameViewModel.Opponent.computer(easy: false))
                    }
                    .pickerStyle(.inline)
                    .onChange(of: vm.opponent) { _ in
                        vm.resetBoard(firstPlayer: .x)
                    }
                }

                Section("First Player") {
                    Picker("First Player", selection: Binding(
                        get: { firstPlayer },
                        set: { newValue in
                            firstRawValue = newValue.rawValue  // update @AppStorage directly
                            vm.resetBoard(firstPlayer: newValue)
                        })) {
                            Text("X").tag(GameViewModel.Player.x)
                            Text("O").tag(GameViewModel.Player.o)
                        }
                        .pickerStyle(.segmented)
                }

                Button("Reset Game", role: .destructive) {
                    vm.resetBoard(firstPlayer: firstPlayer)
                }

                Button("Reset Scores", role: .destructive) {
                    vm.resetScores()
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        showSheet = false
                    }
                }
            }
        }
    }
}
