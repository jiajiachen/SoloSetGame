//
//  ContentView.swift
//  SoloSetGame
//
//  Created by Jia Chen on 2024/11/16.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            Text("Set").font(.largeTitle)
        }
        cards.animation(.default, value: viewModel.cards)
        Spacer()
        HStack() {
            Text("Score: \(String(viewModel.score))")
                .font(.title)
            Spacer()
      
            Button {
                dealCards()
            } label: {
                Text("Deal")
            }
            Spacer()
            Button {
                startNewGame()
            } label: {
                Text("New Game")
            }
        }
        .padding()
    }
    
    var cards: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: viewModel.cards.count,
                size: geometry.size,
                atAspectRatio: 2/3)
            
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card)
                        .padding(4)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                
                }
            }
        }
   
    }
    
    
    func startNewGame() {
        viewModel.startNewGame()
    }
    
    func dealCards() {
        viewModel.dealCards()
    }
    
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        // print(count)
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
        
    }
}

struct CardView: View {
//    let content: String
//    @State var isFaceUp: Bool = false
//    let fillColor: Color?
    
    let card: SetGameModel.Card
    
    init(_ card: SetGameModel.Card) {
        self.card = card
    }
    
    
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 8)
            Group {
               base.foregroundStyle(.white)
               base.strokeBorder(lineWidth: 2)
               base.overlay {

                 VStack(spacing: 8) {
                     ForEach(0..<card.number.rawValue) { _ in
                         applyShading(to:getShape(card))

                     }
                  }.padding(6)
                  

                }
            }
     
        }
        .foregroundStyle(card.fillColor)

    }
    
    @ViewBuilder
    func applyShading(to shape: some Shape) -> some View {
//        var content = getShape(card)
        let color = card.color.toColor()
        switch card.shading {
        case .solid:
            shape.fill(color)
        case .striped:
            shape.stroke(color)
                .overlay(
                    shape
                        .fill(color)
                        .mask(StripedPattern(use: color))
                )
        case .open:
            shape.stroke(color, lineWidth: 2)
        }
    }
}

struct StripedPattern: View {
    var color: Color
    init(use color: Color) {
        self.color = color
    }
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                stride(from: 0, to: geometry.size.width, by: 4).forEach { x in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
            }
            .stroke(color, lineWidth: 1)
        }
    }
}

func getShape(_ card: SetGameModel.Card) -> some Shape {
    switch card.shape {
    case CardShape.diamond:
        return Diamond().path(in: CGRect(x: 0, y: 0, width: 50, height: 75))
    case CardShape.squiggle:
        return Rectangle().path(in: CGRect(x: 0, y: 0, width: 50, height: 75))
    case CardShape.oval:
        return Capsule().path(in: CGRect(x: 0, y: 0, width: 50, height: 75))
    }
}



struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y ))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY  ))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y  ))
        path.addLine(to: CGPoint(x: center.x, y: rect.minY))
        path.closeSubpath()
        return path
    }
}



#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
