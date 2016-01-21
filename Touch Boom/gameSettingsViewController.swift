//
//  gameSettingsViewController.swift
//  Touch Boom
//
//  Created by Jeremy Frick on 5/22/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit


class gameSettingsViewController: UITableViewController {
    
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var voiceSwitch: UISwitch!
    @IBOutlet weak var soundFXSwitch: UISwitch!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backgroundSoundSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let voiceSetting = userDefaults.boolForKey("voice") as Bool!
        {
        self.voiceSwitch.setOn(voiceSetting, animated: true)
        } else {
            userDefaults.setBool(true, forKey: "voice")
        }
        if let soundFXSetting = userDefaults.boolForKey("sound") as Bool!
        {
            self.soundFXSwitch.setOn(soundFXSetting, animated: true)
        } else {
            userDefaults.setBool(true, forKey: "sound")
        }
        if let backgroundSoundSetting = userDefaults.boolForKey("background") as Bool!
        {
            self.backgroundSoundSwitch.setOn(backgroundSoundSetting, animated: true)
        } else {
            userDefaults.setBool(true, forKey: "background")
        }

    }
    
    @IBAction func voiceSwitchChange(sender: AnyObject) {
        if voiceSwitch.on {
            userDefaults.setBool(true, forKey: "voice")
            print("true")
        } else {
            userDefaults.setBool(false, forKey: "voice")
            print("false")
        }
    }
    
    @IBAction func soundFXSwitchChange(sender: UISwitch) {
        if soundFXSwitch.on {
            userDefaults.setBool(true, forKey: "sound")
            print("true")
        } else {
            userDefaults.setBool(false, forKey: "sound")
            print("false")
        }
    }
    

    @IBAction func backgroundMusicSwitchChange(sender: UISwitch) {
        if backgroundSoundSwitch.on {
            userDefaults.setBool(true, forKey: "background")
            print("true")
        } else {
            userDefaults.setBool(false, forKey: "background")
            print("false")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
