//
//  SaveManager.swift
//  Lab1
//
//  Created by Test Testovich on 08/04/2020.
//  Copyright © 2020 Test Testovich. All rights reserved.
//

import Foundation

class SaveManager {
    var bestScore = 0
    var score = 0
    var level = 1
    
    func save() {
        UserDefaults.standard.set(score, forKey: "score")
        UserDefaults.standard.set(level, forKey: "level")
    }
    func saveLevel() {
        UserDefaults.standard.set(level, forKey: "level")
    }

    
    func setBestScore() {
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(score, forKey: "bestScore")
        }
    }
    
    func load() {
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        score = UserDefaults.standard.integer(forKey: "score")
        level = UserDefaults.standard.integer(forKey: "level")
    }
}
