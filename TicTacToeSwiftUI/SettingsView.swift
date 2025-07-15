//
//  SettingsView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 7/14/25.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: GameViewModel

        @AppStorage("firstPlayer") private var firstRawValue = GameViewModel.Player.x.rawValue
        @AppStorage("computerDifficultyEasy") private var difficultyEasy = true

        private var firstPlayer: GameViewModel.Player {
            get { GameViewModel.Player(rawValue: firstRawValue) ?? .x }
            set { firstRawValue = newValue.rawValue }
        }

        var body: some View {
            NavigationStack {
                Form {
                    Section("First Player") {
                        Picker("First Player", selection: Binding(
                            get: { firstPlayer },
                            set: { newValue in
                                firstRawValue = newValue.rawValue
                                vm.resetBoard(firstPlayer: newValue)
                            })) {
                                Text("X").tag(GameViewModel.Player.x)
                                Text("O").tag(GameViewModel.Player.o)
                            }
                            .pickerStyle(.segmented)
                    }

                    Section("Computer Difficulty") {
                        Picker("Difficulty", selection: $difficultyEasy) {
                            Text("Easy").tag(true)
                            Text("Hard").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: difficultyEasy) { newValue in
                            vm.opponent = .computer(easy: newValue)
                            vm.resetBoard(firstPlayer: firstPlayer)
                        }
                    }

                    Section {
                        Button("Reset Scores") {
                            vm.resetScores()
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
