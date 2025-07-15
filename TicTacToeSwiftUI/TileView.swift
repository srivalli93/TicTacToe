//
//  TileView.swift
//  TicTacToeSwiftUI
//
//  Created by Srivalli Kanchibotla on 7/14/25.
//

import SwiftUI

struct TileView: View {
    let symbol: String?
    let tapAction: () -> Void          // ▼ closure comes in

    var body: some View {
        ZStack {
            if #available(iOS 26.0, *) {
                Rectangle()
                    .fill(.clear)          // transparent but has layout
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            } else {
                Rectangle()
                    .fill(.clear)
            }

            if let sym = symbol {
                Image(systemName: sym)
                    .resizable()
                    .scaledToFit()
                    .padding(12)
                    .foregroundStyle(.primary)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(4)
        .contentShape(Rectangle())     // ▼ entire square is tappable
        .onTapGesture {                // ▼ gesture lives here
            tapAction()
        }
    }
}

