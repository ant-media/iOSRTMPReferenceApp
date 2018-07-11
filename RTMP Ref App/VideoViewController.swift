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
        self.session.delegate = self
        self.session.preView = self.view
    }

    @IBAction func beautyTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension VideoViewController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("State: \(state.hashValue)")
        switch state {
            case LFLiveState.ready:
                break
            case LFLiveState.pending:
                break
            case LFLiveState.start:
                break
            case LFLiveState.error:
                break
            case LFLiveState.stop:
                break
            default:
                break
        }
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        let message: String = Messages.getLocalizedError(with: errorCode)
        print("Error: \(errorCode.rawValue) -> \(message)")
        AlertHelper.getInstance().show("Error", message: message)
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("Debug info: \(debugInfo.debugDescription)")
    }
}
