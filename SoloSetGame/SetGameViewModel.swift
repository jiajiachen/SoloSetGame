//
//  SetGame.swift
//  SoloSetGame
//
//  Created by Jia Chen on 2024/11/16.
//

import Foundation

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGameModel.Card
    
    private static func createSetGame() -> SetGameModel {

        return SetGameModel()
    }
    
    @Published private var model = createSetGame()
    
    func startNewGame() {
        resumeScore()
        model = SetGameViewModel.createSetGame()
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    var cards: Array<Card> {
        return model.cards.filter { !$0.isInDeck && $0.show}
    }
    
    var cardsCountIndeck: Int {
        return model.cards.filter { $0.isInDeck }.count
    }
    
    var dealCardList: Array<Card> {
        return model.cards

    }
    
    var score: Int {
        return model.score
    }
    
    func resumeScore() {
        model.resumeScore()
    }
    
}
