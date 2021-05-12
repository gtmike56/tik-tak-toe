//
//  ContentView.swift
//  Shared
//
//  Created by Mikhail Udotov on 2021-05-06.
//

import SwiftUI

struct BoardView: View {
        
    @StateObject private var modelView = BoardViewModel()
    @AppStorage("circleColor") private var circleColor: Int = 0

    @State private var presentColorPicker = false
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State private var preferedColorScheme: ColorScheme = .dark
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: modelView.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            BoardCell(geometryProxy: geometry, index: modelView.moves[i]?.boardIndex, circleColor: circleColor)
                            MoveIndicator(imageSystemString: modelView.moves[i]?.indicator ?? "", geometryProxy: geometry, index: modelView.moves[i]?.boardIndex)
                        }.rotation3DEffect(
                            .init(degrees: modelView.moves[i] == nil ? 180 : 0),
                            axis:(x: 0.0, y:1.0, z: 0.0),
                            anchor: .center,
                            anchorZ: 0.0,
                            perspective: 1.0
                        ).onTapGesture {
                            modelView.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { presentColorPicker.toggle() }, label: {
                        Image(systemName: "gearshape").resizable().frame(width: geometry.size.width/10, height: geometry.size.width/10).accentColor(colorScheme == .dark ? .white : .black)
                    })
                    Spacer()
                    Button(action: {
                        if colorScheme == .dark {
                            preferedColorScheme = .light
                        } else {
                            preferedColorScheme = .dark
                        }
                    }, label: {
                        Image(systemName: colorScheme == .dark ? "circle.lefthalf.fill" : "circle.righthalf.fill").resizable().frame(width: geometry.size.width/10, height: geometry.size.width/10).accentColor(colorScheme == .dark ? .white : .black)
                    })
                    Spacer()
                }
                .sheet(isPresented: $presentColorPicker, onDismiss: {
                    modelView.resetGame()
                }, content: {
                    SettingsView(colorIndex: $circleColor, aiGame: $modelView.competitorAI, aiDifficultyIndex: $modelView.aiDifficulty)
                        .preferredColorScheme(preferedColorScheme)
                })
            }
            .padding()
            .disabled(modelView.boardDisabled)
            .alert(item: $modelView.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.text, dismissButton: .default(alertItem.buttonTitle, action: {
                    modelView.resetGame()
                }))
            }
        }.preferredColorScheme(preferedColorScheme)
        .onAppear(perform: {
            preferedColorScheme = colorScheme
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
