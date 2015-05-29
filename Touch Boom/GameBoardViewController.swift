//
//  ViewController.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/14/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameKit
//import QuartzCore

class GameBoardViewController: UIViewController, AVAudioPlayerDelegate {
    
    var sound = speach()
    var scoring = ScoreBuilder()
    var highScore: Int!
    let viewTransitionDelegate = TransitionDelegate()
    
    var background = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Spaceship-Engine-Ambience", ofType: "wav")!)
    var blasterSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("8Bit-Aggresive-Laser-Bleep-02", ofType: "wav")!)
    var backgroundplayer = AVAudioPlayer()
    var audioSession = AVAudioSession()

    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var scoreBoard: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    let emitterLayer = CAEmitterLayer()
    var emitterCell = CAEmitterCell()
    var firstTouch = false
    var gameOver = false
    let startingScore = "0"
    var previousTouchPoint = CGPoint()
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth: UInt32 = 0
    var screenHeight: UInt32 = 0
    var touchArea: CGRect!
    var emitterLocation: CGPoint!
    var blaster: SystemSoundID = 0
    var backgroundMusicPlaying: Bool = false
    var backgrounMusicInterrupted: Bool!
    var voiceSetting = Bool()
    var soundFXSetting = Bool()
    var backgroundSetting = Bool()
    var miss = Bool()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get voice and sound settings
        voiceSetting = userDefaults .boolForKey("voice")
        soundFXSetting = userDefaults.boolForKey("sound")
        backgroundSetting = userDefaults.boolForKey("background")
        
        //sound effects setup
        if backgroundSetting {
            configureAudioSession()
        }
        if soundFXSetting {
            configureSystemSound()
        }
        
        //Background Sound
        if backgroundSetting {
            backgroundplayer = AVAudioPlayer(contentsOfURL: background, error: nil)
            backgroundplayer.delegate = self
            backgroundplayer.numberOfLoops = -1
            backgroundplayer.volume = 0.5
            backgroundplayer.prepareToPlay()
        }

        
        //screen setup
        setUpEmitterLayer()
        screenHeight = UInt32(screenSize.height)
        screenWidth = UInt32(screenSize.width)
        self.ScoreLabel.text = scoring.resetScore()
        
        //Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        //setup horizontal effect
        let horizontalMontionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMontionEffect.minimumRelativeValue = -10
        horizontalMontionEffect.maximumRelativeValue = 10
        
        //create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMontionEffect]
        
        //add both effect to the view
        view.addMotionEffect(group)
        
        //build Emitter
        createEmitter()
        if backgroundSetting {
        backgroundplayer.play()
        }
        
        
    }
    
    // MARK: Emitter and Emitter Layer Setup
    
    func setUpEmitterLayer() {
        emitterLayer.frame = view.bounds
        emitterLayer.renderMode = kCAEmitterLayerAdditive
        emitterLayer.drawsAsynchronously = true
        
    }
    
    func setUpEmitterCell() {
        emitterCell.contents = UIImage(named: "spark")?.CGImage
        
        emitterCell.velocity = 0.0
        emitterCell.velocityRange = 1000.0
        
        emitterCell.color = UIColor.blackColor().CGColor
        emitterCell.redRange = 1.0
        emitterCell.greenRange = 1.0
        emitterCell.blueRange = 1.0
        emitterCell.alphaRange = 0.0
        emitterCell.redSpeed = 0.0
        emitterCell.greenSpeed = 0.0
        emitterCell.blueSpeed = 0.0
        emitterCell.alphaSpeed = -1.0
        
        emitterCell.alphaRange = 0.2
        
        emitterCell.scale = 0.3
        emitterCell.scaleRange = 0.2
        emitterCell.scaleSpeed = -0.4
        
        let zeroDegreesInRadians = degreesToRadians(0.0)
        emitterCell.spin = degreesToRadians(130.0)
        emitterCell.spinRange = zeroDegreesInRadians
        emitterCell.emissionRange = degreesToRadians(360.0)
        
        emitterCell.lifetime = 1.0
        emitterCell.birthRate = 200.0
        emitterCell.xAcceleration = 2.0
        emitterCell.yAcceleration = 2.0
    }
    
    func setEmitterPosition(x: CGFloat, y:CGFloat) {
        emitterLayer.emitterPosition = CGPointMake(x, y)
    }
    
    func degreesToRadians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * M_PI / 180.0)
    }
    
    func createEmitter() {
        setUpEmitterCell()
        
        //setup Emitter location
        emitterLocation = createNewEmitterLocation()
        setEmitterPosition(emitterLocation.x, y: emitterLocation.y)
        
        //setup touch area for the emitter
        touchArea = CGRectMake(emitterLocation.x - 30.0, emitterLocation.y - 30.0, 60.0, 60.0)
        
        //add emitter to layer and layer to view
        emitterLayer.emitterCells = [emitterCell]
        view.layer.addSublayer(emitterLayer)
    }
    
    func missedShot(){
        var newEmitterLocation = createNewEmitterLocation()
        var animation = CABasicAnimation()
        animation.keyPath = "testing"
        animation.fromValue = emitterLayer .valueForKey("position")
        animation.toValue = NSValue(CGPoint: newEmitterLocation)
        animation.duration = 20.00
        view.layer.position = newEmitterLocation
        view.layer .addAnimation(animation, forKey: "position")
        
        
//        let path = UIBezierPath()
//        path.moveToPoint(newEmitterLocation)
//        let anim = CAKeyframeAnimation(keyPath: "position")
//        anim.path = path.CGPath
//        anim.duration = 15.0
//        self.emitterLayer.addAnimation(anim, forKey: "test")
    }
    
    func createNewEmitterLocation()->CGPoint {
        var randomY = CGFloat(arc4random_uniform(screenHeight))
        var randomX = CGFloat(arc4random_uniform(screenWidth))
        
        return CGPointMake(randomX, randomY)
    }

    // MARK: Game Logic
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //get location where user touched the screen and then play the sound effect
        let touchPoint = (touches.first as! UITouch).locationInView(view)
        if soundFXSetting {
            playSystemSound()
        }
        //if this is the first touch of the round then begin the timer
        if !(firstTouch) {
            firstTouch = true
            let timer = NSTimer.scheduledTimerWithTimeInterval(50, target: self, selector: Selector("endGame"), userInfo: nil, repeats: false)
        }
        //If the game is not over then check if the touch was in the target area, play the sound and calculate the score
        if !(gameOver){
            if (CGRectContainsPoint(touchArea, touchPoint)){
                if voiceSetting {
                    sound.PlayBoom()
                }
                scoring.bonusQualifier(emitterLocation, newTouch: touchPoint)
                self.ScoreLabel.text = toString(scoring.addToScore())
                createEmitter()
            } else {
                if voiceSetting {
                    sound.pewPew()
                    missedShot()
            }
               // createEmitter()
            }
        }
    }
    
    func endGame(){
        //kill all in-game assets and set gameOver flag to true
        emitterLayer.emitterCells = []
        gameOver = true
        if backgroundSetting {
            backgroundplayer.stop()
            }
        if soundFXSetting {
            AudioServicesDisposeSystemSoundID(blaster)
        }
        //save score and segue to end game screen
        let currentScore = ScoreLabel.text?.toInt()
        highScore = scoring.compareScores(currentScore!)
        reportScoreToGameCenter()
        self.performSegueWithIdentifier("toEndGame", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! GameOverViewController
        destinationViewController.transitioningDelegate = viewTransitionDelegate
        destinationViewController.modalPresentationStyle = .Custom
        destinationViewController.currentGameScore = ScoreLabel.text!
        destinationViewController.highScore = highScore
    }
    
    // MARK: Audio Setup
    
    func configureAudioSession() {
        
        self.audioSession = AVAudioSession.sharedInstance()
        var err: NSError?
        //check if other audio is playing
        if (self.audioSession.otherAudioPlaying) {
            self.audioSession.setCategory(AVAudioSessionCategorySoloAmbient, error: &err)
            self.backgroundMusicPlaying = false
        } else {
            self.audioSession.setCategory(AVAudioSessionCategoryAmbient, error: &err)
        }
        if ((err) != nil) {
            println("Error \(err)")
        }
    }
    
    func configureSystemSound() {
        if soundFXSetting {
        AudioServicesCreateSystemSoundID(blasterSound as! CFURL, &blaster)
        }
    }
    
    func playSystemSound(){
        if soundFXSetting {
            AudioServicesPlaySystemSound(self.blaster)
        }
    }
    
    func tryPlayMusic() {
            if (backgroundMusicPlaying || self.audioSession.otherAudioPlaying) {
                return
            }
            backgroundplayer.prepareToPlay()
            dispatch_async(dispatch_get_main_queue(), {
                backgroundplayer.play()
            })
            self.backgroundMusicPlaying = true
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        if backgroundSetting {
            self.backgrounMusicInterrupted = true
            self.backgroundMusicPlaying = false
        }
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer!, withOptions flags: Int) {
        if backgroundSetting {
            self.tryPlayMusic()
            self.backgrounMusicInterrupted = false
        }
    }

    // MARK: GameCenter
    
    func reportScoreToGameCenter() {
        var leaderboardID = "TouchBoomLeaderBoard"
        var sScore = GKScore(leaderboardIdentifier: leaderboardID)
        var score = ScoreLabel.text?.toInt()
        sScore.value = Int64(score!)
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                println("Score submitted")
                
            }
        })
        
        
        
    }
}


