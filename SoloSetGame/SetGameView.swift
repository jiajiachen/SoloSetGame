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
//                   VStack(spacing: 8) {
//                       ForEach(0..<3) { _ in
//                           Capsule()
//                                .fill(Color.pink)
//                           
//                           
//                      }
//                   }.padding(6)
//                   Diamond()
//                       .stroke(Color.green, lineWidth: 1)
//                       .frame(width: 26, height: 16)
                 
                       
                   ZStack {
                       Squiggle()
                           .stroke(Color.blue.opacity(0.5), lineWidth: 1)
//
//                             ForEach(0..<50) { index in
//                                 Rectangle()
//                                     .fill(Color.white) // 纹理颜色
//                                     .frame(width: 2, height: 20)
//                                     .offset(x: CGFloat(index * 5), y: 0)
//                                     
//                             }
                         }.frame(width: 20, height: 20)

                }
            }
     
        }
        .foregroundStyle(card.fillColor)

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

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.height/3))
               
       let width = rect.width
       let height = rect.height
       let spacing = width / 4
       
       path.addCurve(
        to: CGPoint(x: rect.maxX * 4/5, y: rect.minY),
        control1: CGPoint(x: spacing, y: -rect.height * 1/4),
        control2: CGPoint(x: rect.width / 2, y: rect.height * 3 / 4)
       )
//        path.addCurve(
//            to: CGPoint(x: rect.minX, y: rect.midY),
//            control1: CGPoint(x: width - spacing, y: rect.maxY + rect.height / 2),
//            control2: CGPoint(x: spacing, y: rect.maxY)
//        )
        //path.closeSubpath()
        return path
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
