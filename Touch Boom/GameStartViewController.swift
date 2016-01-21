//
//  GameStartScreen.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/18/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class GameStartViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var gameInfoText: UILabel!
    @IBOutlet weak var gameInfoCloseButton: UIButton!
    @IBOutlet weak var gameStartButton: UIButton!
    @IBOutlet weak var gameTitle: UIImageView!
    @IBOutlet weak var gameInfoButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    lazy var audioPlayer = AVAudioPlayer()
    var entrance = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("FirefightL1", ofType: "mp3")!)
    lazy var gameCenterDefaultLeaderBoard = String()
    lazy var gameCenterEnabled = Bool()
    lazy var sound = speach()
    lazy var timer = NSTimer()
    lazy var viewTransitionDelegate = TransitionDelegate()
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var BackgroundSetting = Bool()
    var voiceSetting = Bool()
    
    
    override func viewDidLoad() {
        voiceSetting = userDefaults .boolForKey("voice")
        BackgroundSetting = userDefaults.boolForKey("background")
        
        self.authenticateLocalPlayer()
        
        //setup background audio and play if enabled
        if BackgroundSetting {
            audioPlayer = try! AVAudioPlayer(contentsOfURL: entrance)
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0.3
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        //setup game info popup view
        gameInfoView.alpha = 0.0
        gameInfoView.layer.cornerRadius = 5
        gameInfoView.layer.masksToBounds = true
        gameInfoView.layer.borderColor = UIColor.greenColor().CGColor
        gameInfoView.layer.borderWidth = 1.0
        gameInfoText.alpha = 0.0
        
        //setup close button
        gameInfoCloseButton.layer.cornerRadius = 7
        gameInfoCloseButton.layer.masksToBounds = true
        gameInfoCloseButton.layer.borderWidth = 1.0
        gameInfoCloseButton.layer.borderColor = UIColor.greenColor().CGColor
        gameInfoCloseButton.alpha = 0.0
        
        
        //set alpha of graphical elements
        self.gameStartButton.alpha = 0.0
        self.gameTitle.alpha = 0.0
        
        //play voice if enabled
        if voiceSetting {
            sound.startGame()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("animateButton"), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, animations: {self.gameTitle.alpha = 1.0})
    }
    
    func animateButton() {
        UIView.animateWithDuration(1.0, animations: {self.gameStartButton.alpha = 1.0})

    }
    
    @IBAction func gameInfoButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(1.0, animations: {self.gameInfoView.alpha = 0.75})
        UIView.animateWithDuration(1.0, animations: {self.gameInfoText.alpha = 1.0})
        UIView.animateWithDuration(1.0, animations: {self.gameInfoCloseButton.alpha = 1.0})
    }
    
    @IBAction func gameInfoCloseButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(1.5, animations: {self.gameInfoView.alpha = 0.0})
        UIView.animateWithDuration(1.0, animations: {self.gameInfoText.alpha = 0.0})
        UIView.animateWithDuration(0.5, animations: {self.gameInfoCloseButton.alpha = 0.0})
    }
    
    @IBAction func gameSettingButtonPressed(sender: AnyObject) {
        if BackgroundSetting {
            audioPlayer.stop()
        }
    }
    
    @IBAction func startGameButtonPressed(sender: AnyObject) {
        if BackgroundSetting {
            audioPlayer.stop()
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gamePlay" {
            let destinationViewController = segue.destinationViewController as! GameBoardViewController
            destinationViewController.transitioningDelegate = viewTransitionDelegate
            destinationViewController.modalPresentationStyle = .Custom
        } else {
            let destinationViewController = segue.destinationViewController as! gameSettingsViewController
            destinationViewController.transitioningDelegate = viewTransitionDelegate
            destinationViewController.modalPresentationStyle = modalPresentationStyle
        }
    }

   // MARK: Game Center
    func authenticateLocalPlayer() {
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.presentViewController(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                print("Local player already authenticated")
                self.gameCenterEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gameCenterDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
                
            } else {
                self.gameCenterEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
            
        }
        
        
    }
}

