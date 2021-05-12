//
//  SettingsView.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-09.
//

import SwiftUI

struct SettingsView: View {
        
    @Binding var colorIndex: Int
    
    @Binding var aiGame: Bool
    
    @Binding var aiDifficultyIndex: Int
    
    var aiDifficulty = ["Easy", "Medium", "Hard"]
    var body: some View {
        
        let swatches = [
            Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.gray, Color.pink, Color.purple
        ]
        
        let columns = [
            GridItem(.adaptive(minimum: 60))
        ]
        
        NavigationView {
            Form {
                Section(header: Text("Game Settings")) {
                    Toggle("Game with AI", isOn: $aiGame)
                }
                Picker(selection: $aiDifficultyIndex, label: Text("AI Difficulty")) {
                    ForEach(0 ..< aiDifficulty.count) {
                        Text(self.aiDifficulty[$0])
                    }
                }.disabled(!aiGame)
                Section(header: Text("Accent Colours")) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(swatches.enumerated()), id: \.1){ (index, swatch) in
                            ZStack {
                                Circle()
                                    .fill(swatch)
                                    .frame(width: 50, height: 50)
                                    .onTapGesture(perform: {
                                        colorIndex = index
                                    })
                                    .padding(10)
                                if colorIndex == index {
                                    Circle()
                                        .stroke(swatch, lineWidth: 5)
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
                    }
                    .padding(10)
                }
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1")
                    }
                }
                Section {
                    Button(action: {
                        aiGame = true
                        aiDifficultyIndex = 2
                        colorIndex = 0
                    }) {
                        Text("Reset All Settings")
                    }
                }
            }.accentColor(swatches[colorIndex])
            .navigationTitle("Settings")
        }.accentColor(swatches[colorIndex])
    }
}
