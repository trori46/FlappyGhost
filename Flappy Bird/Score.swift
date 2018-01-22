//
//  Score.swift
//  Flappy Bird
//
//  Created by Viktoriia Rohozhyna on 1/16/18.
//  Copyright © 2018 Viktoriia Rohozhyna. All rights reserved.
//

import Foundation

class Score {
    //var scores : [String: Int]
    let defaults = UserDefaults.standard
    var items = [(key: String, value: Int)]()
    var scores = UserDefaults.mutableArrayValue(forKey:"Scores") as? [(key: String, value: Int)] ?? [(key: String, value: Int)]()
    //var scores : [String: Int] = [:]
    //var maxScore = Int()
   //var minScore = Int()
    
    func appendNewScore(newName: String, newScore: Int) {
        if scores.capacity <= 5  {
            scores.append((key: newName, value: newScore))
            UserDefaults.standard.set(scores, forKey: "Scores")
            
        } else {
            if newScore > minOfScores() {
                scores = scores.sorted(by: { $0.value < $1.value })
                scores = [scores.removeLast()]
                scores.append((key: newName, value: newScore))
                scores = scores.sorted(by: { $0.value < $1.value })
                UserDefaults.standard.set(scores, forKey: "Scores")
            }
        }
    }
    
    func maxOfScores() -> Int {
        if !scores.isEmpty {
            let maxScore = scores.max(by: { (a, b) -> Bool in
                a.value > b.value
            })
            return (maxScore?.value)!
        }
        return 0
    }
    func minOfScores() -> Int {
        if !scores.isEmpty {
            let minScore = scores.min(by: { (a, b) -> Bool in
                a.value < b.value
            })
            return (minScore?.value)!
        }
        return 0
    }
}
