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
    
    @IBOutlet weak var statusLabel: UILabel!
    
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
        self.session.running = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://\(self.streamUrl!)/LiveApp/\(self.streamName!)"
        session.startLive(stream)
    }

    @IBAction func beautyTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.session.stopLive()
        self.dismiss(animated: true, completion: nil)
    }
}

extension VideoViewController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("State: \(state.hashValue)")
        switch state {
            case LFLiveState.ready:
                statusLabel.text = "Status: Not connected"
                break
            case LFLiveState.pending:
                statusLabel.text = "Status: Connecting"
                break
            case LFLiveState.start:
                statusLabel.text = "Status: Live"
                break
            case LFLiveState.error:
                statusLabel.text = "Status: Error"
                break
            case LFLiveState.stop:
                statusLabel.text = "Status: Stop"
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
