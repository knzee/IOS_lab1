//
//  Player.swift
//  Lab1
//
//  Created by Test Testovich on 30/03/2020.
//  Copyright © 2020 Test Testovich. All rights reserved.
//

import Foundation
import UIKit

class Player:UIImageView {
    var fireRate = 30
    var health = 5
    var bestScore = 0
    var score = 0
    var level = 1
    var isDead = false
    
    var direction : CGFloat = 0
    var speed : CGFloat = 10
    
    func calcMS() -> CGFloat {
        return speed*direction
    }
    
    func save() {
        UserDefaults.standard.set(score, forKey: "score")
        UserDefaults.standard.set(level, forKey: "level")
    }
    func saveLevel() {
        UserDefaults.standard.set(level, forKey: "level")
    }
    
    func setBestScore(score: Int) {
        bestScore = score
        UserDefaults.standard.set(score, forKey: "bestScore")
    }
    
    func load() {
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        score = UserDefaults.standard.integer(forKey: "score")
        level = UserDefaults.standard.integer(forKey: "level")
    }
    
    func die() {
        if score > bestScore {
            setBestScore(score: score)
        }
        isDead = true
        level = 1
        score = 0
        save()
        
    }
    
    func resurrect() {
        health = 5
        isDead = false
    }
    
}
