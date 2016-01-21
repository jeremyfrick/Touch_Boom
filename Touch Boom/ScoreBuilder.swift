//
//  ScoreBuilder.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/14/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit

class ScoreBuilder: NSObject {
    lazy var score = 0
    lazy var bonusMultiplier = 1
    lazy var sound = speach()
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var voiceSetting = Bool()
    
    func addToScore() -> Int {
    let randomPoints = (Int(arc4random_uniform(15890)) * bonusMultiplier)
        print("\(score)")
        score += randomPoints
        return score
    }
    
    func resetScore() ->String {
        score = 0
        return "0"
    }
    
    func bonusQualifier(oldTouch:CGPoint, newTouch:CGPoint) {
        //determines if the touchpoint was the exact emitter location. If it was a bonus multiplier is randomly created
        if oldTouch == newTouch {
            print("NO BONUS")
        }else {
            print("BOUNS")
            bonusMultiplier = (Int(arc4random_uniform(10) + 1))
            print("Bonus multiplier: \(bonusMultiplier)")
            if voiceSetting {
                sound.bonusAction()
            }
        }
    }
    
    func compareScores(currentScore:Int) -> Int {
        //takes the current game score and then loads the current saved high score, compares and then saves and returns the highest score.
        if let highScoreNotNil = userDefaults.integerForKey("highScore") as Int? {
            if currentScore >= highScoreNotNil {
                userDefaults.setInteger(currentScore, forKey: "highScore")
                return currentScore
            } else if currentScore < highScoreNotNil {
                return highScoreNotNil
        } else {
            userDefaults.setInteger(currentScore, forKey: "highScore")
        }
    }
        return currentScore
}
}