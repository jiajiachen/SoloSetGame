//
//  SetGameModel.swift
//  SoloSetGame
//
//  Created by Jia Chen on 2024/11/16.
//

import Foundation
import SwiftUI

struct SetGameModel {

    private(set) var cards: Array<Card>
    private(set) var dealtCards: Array<Card>
    private(set) var score = 0
    
    init() {
        var id = 0
        cards = []
        dealtCards = []
        for number in CardNumber.allCases {
            for color in CardColor.allCases {
                for shape in CardShape.allCases {
                    for shading in CardShading.allCases {
                        cards.append(Card(id: String(id), number: number, shape: shape, shading: shading, color: color))
                        id += 1
                    }
                }
            }
        }
        shuffle()
        for index in 0..<12 {
            setCardDeal(cards[index])
            dealtCards.append(cards[index])
        }
      
    }
    
    mutating func choose(_ card: Card) {

    }
    
    mutating func dealCards() {
    
        let cards = cards.filter { $0.isInDeck }
        if cards.count > 0 {
            for index in 0..<3 {
                setCardDeal(cards[index])
                dealtCards.append(cards[index])
            }
        }
      
    }
    
    mutating func setCardDeal(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id} ) {
            cards[chosenIndex].isInDeck = false
        }
       
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func resumeScore() {
        score = 0
    }
    
    struct Card: Identifiable, Equatable {
        var id: String
        var number: CardNumber
        var shape: CardShape
        var shading: CardShading
        var color: CardColor
        var isSelected: Bool = false
        var isMatched: Bool = false
        var fillColor: Color = .orange
        var isInDeck: Bool = true
    }
    
    enum CardNumber: CaseIterable {
        case one
        case two
        case three
    }
    enum CardColor: CaseIterable {
        case green
        case purple
        case red
    }
    enum CardShape: CaseIterable {
        case diamond
        case squiggle
        case oval
    }
    enum CardShading: CaseIterable {
        case solid
        case striped
        case open
    }

}
