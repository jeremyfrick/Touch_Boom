//
//  GameOverViewController.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/18/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit
import GameKit

class GameOverViewController: UIViewController, GKGameCenterControllerDelegate {
    lazy var sound = speach()
    @IBOutlet weak var gameOverLabel: UIImageView!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var currentGameScoreLabel: UILabel!
    @IBOutlet weak var yourScoreImage: UIImageView!
    @IBOutlet weak var exitNow: UIButton!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var gameCenterButton: UIBarButtonItem!
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var voiceSetting = Bool()
    var currentGameScore = String()
    var highScore = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        voiceSetting = userDefaults.boolForKey("voice")
        currentGameScoreLabel.text = currentGameScore
        highScoreLabel.text = toString(highScore)
    }
    override func viewDidAppear(animated: Bool) {
        if voiceSetting {
            sound.playAgain()
        }
        UIView.animateWithDuration(2.0, animations: {self.gameOverLabel.alpha = 1.0})
        UIView.animateWithDuration(2.0, animations: {self.playAgainButton.alpha = 1.0})
        UIView.animateWithDuration(2.0, animations: {self.currentGameScoreLabel.alpha = 1.0})
        UIView.animateWithDuration(2.0, animations: {self.yourScoreImage.alpha = 1.0})
        UIView.animateWithDuration(2.0, animations: {self.exitNow.alpha = 1.0})
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        var shareText = "I got a score of \(currentGameScore) killing evil emitters in Touch Boom"
        let itemsToShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        let popoverVC = activityViewController as UIViewController
        popoverVC.modalPresentationStyle = .Popover
        let popoverController = popoverVC.popoverPresentationController
        popoverController?.sourceView = toolBar as UIView
        popoverController?.sourceRect = toolBar.bounds
        popoverController?.permittedArrowDirections = .Any
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Game Center
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func gameCenterButtonPressed(sender: AnyObject) {
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterViewController.leaderboardIdentifier = "TouchBoomLeaderBoard"
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }

}
