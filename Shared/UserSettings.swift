//
//  Settings.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-10.
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var competitorAI: Bool {
        didSet {
            UserDefaults.standard.set(competitorAI, forKey: "aiCompetitor")
        }
    }
    @Published var aiDifficulty: Int {
        didSet {
            UserDefaults.standard.set(aiDifficulty, forKey: "aiDifficulty")
        }
    }
    @Published var circleColor: Int {
        didSet {
            UserDefaults.standard.set(circleColor, forKey: "circleColor")
        }
    }
    init() {
        self.competitorAI = UserDefaults.standard.object(forKey: "aiCompetitor") as? Bool ?? true
        self.aiDifficulty = UserDefaults.standard.object(forKey: "aiDifficulty") as? Int ?? 1
        self.circleColor = UserDefaults.standard.object(forKey: "circleColor") as? Int ?? 0
    }
}
