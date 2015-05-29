//
//  boom.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/14/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit
import AVFoundation

class speach: NSObject {
    lazy var synthesizer = AVSpeechSynthesizer()

   
    func PlayBoom() {
        if synthesizer.speaking {
            return
        }
        let utterance = AVSpeechUtterance(string: "KAW BOOM")
        utterance.pitchMultiplier = 0.5
        synthesizer.speakUtterance(utterance)
    }
    
    func bonusAction() {
        if synthesizer.speaking {
            return
        }
        let utterance = AVSpeechUtterance(string: "Bonus")
        utterance.pitchMultiplier = 0.5
        synthesizer.speakUtterance(utterance)
    }
    
    func startGame() {
        let utterance = AVSpeechUtterance(string: "Do you want to play a game?")
        utterance.rate = 0.05
        utterance.pitchMultiplier = 0.5
        synthesizer.speakUtterance(utterance)
    }
    
    func playAgain() {
        let utterance = AVSpeechUtterance(string: "Would you like to play again?")
        utterance.rate = 0.05
        utterance.pitchMultiplier = 0.5
        synthesizer.speakUtterance(utterance)
    }
    
    func pewPew() {
        let missArray = ["miss","so close","drat","oh the humanity","You can do it"]
        let randomIndex = Int(arc4random_uniform(UInt32(missArray.count)))
        let utterance = AVSpeechUtterance(string: (missArray[randomIndex]))
        utterance.rate = 0.05
        utterance.pitchMultiplier = 0.5
        synthesizer.speakUtterance(utterance)
    }

}
