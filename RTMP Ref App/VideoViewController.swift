//
//  VideoViewController.swift
//  RTMP Ref App
//
//  Created by Oğulcan on 11.07.2018.
//  Copyright © 2018 AntMedia. All rights reserved.
//

import UIKit
import LFLiveKit

class VideoViewController: UIViewController {
    
    var streamUrl: String!
    var streamName: String!
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.streamUrl = Defaults[.server]!
        self.streamName = Defaults[.room]!
    }

    @IBAction func beautyTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
