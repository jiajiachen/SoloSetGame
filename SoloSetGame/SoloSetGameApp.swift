//
//  SoloSetGameApp.swift
//  SoloSetGame
//
//  Created by Jia Chen on 2024/11/16.
//

import SwiftUI

@main
struct SoloSetGameApp: App {
    @StateObject var game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: game)
        }
    }
}
