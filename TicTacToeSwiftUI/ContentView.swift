//
//  ContentView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 7/14/25.
//


import SwiftUI

enum GameMode: String, CaseIterable, Identifiable {
    case human, computer
    var id: String { rawValue }
}

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    @AppStorage("computerDifficultyEasy") private var difficultyEasy = true
    @State private var selectedGameMode: GameMode = .human

    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 16) {
                    Picker("Game Mode", selection: $selectedGameMode) {
                        ForEach(GameMode.allCases) { mode in
                            Text(mode.rawValue.capitalized).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    GameView(vm: vm)
                }
                .navigationTitle("Tic Tac Toe")
                .onChange(of: selectedGameMode) { updateOpponent() }
                .onChange(of: difficultyEasy) { newValue in
                    if selectedGameMode == .computer {
                        updateOpponent()
                    }
                }
                .onAppear { updateOpponent() }
            }
            .tabItem {
                Label("Game", systemImage: "gamecontroller.fill")
            }

            SettingsView(vm: vm)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }

    private func updateOpponent() {
        vm.opponent = (selectedGameMode == .computer) ? .computer(easy: difficultyEasy) : .human
        vm.resetBoard()
    }
}

#Preview {
    ContentView()
}
