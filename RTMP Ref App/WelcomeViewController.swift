//
//  WelcomeViewController.swift
//  RTMP Ref App
//
//  Created by Oğulcan on 8.07.2018.
//  Copyright © 2018 AntMedia. All rights reserved.
//

import UIKit
import LFLiveKit
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var actionContainer: UIView! {
        didSet {
            self.actionContainer.alpha = 0
        }
    }
    @IBOutlet weak var serverButton: UIButton! {
        didSet {
            if let server = Defaults[.server] {
                if (server.count > 0) {
                    self.serverButton.setTitle("Server ip: \(server)", for: .normal)
                }
            }
        }
    }

    var isConnected = false
    var tapGesture: UITapGestureRecognizer!
    var sessionState: LFLiveState = LFLiveState.ready
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.session.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setGesture()
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
            self.logoTopAnchor.constant = 40
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.5, animations: {
                self.actionContainer.alpha = 1
                self.view.layoutIfNeeded()
            })
        })
    }
    
    @IBAction func connectButton(_ sender: UIButton ) {
        if roomField.text!.count == 0 {
            AlertHelper.getInstance().show("Caution!", message: "Please fill room field")
        } else if (Defaults[.server] ?? "").count < 2 {
            AlertHelper.getInstance().show("Caution!", message: "Please set server ip")
        } else {
            print("Ready to go")
            let url = Defaults[.server]!
            let room = roomField.text!
            
            let stream = LFLiveStreamInfo()
            stream.url = "rtmp://\(url)/LiveApp/\(room)"
            session.startLive(stream)
        }
    }
    
    @IBAction func refreshTapped(_ sender: UIButton) {
        if let room = Defaults[.room] {
            self.roomField.text = room
        }
    }
    
    @IBAction func serverTapped(_ sender: UIButton) {
        AlertHelper.getInstance().addOption("Save", onSelect: {
            (address) in
            if (address!.count > 0) {
                self.serverButton.setTitle("Server ip: \(address!)", for: .normal)
                Defaults[.server] = address
            } else {
                self.serverButton.setTitle("Set server ip", for: .normal)
                Defaults[.server] = ""
            }
        })
        AlertHelper.getInstance().showInput(self, title: "IP Address", message: "Please enter your server address (no need protocol)")
    }
    
    private func setGesture() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.toggleContainer))
        self.tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleContainer() {
        self.view.endEditing(true)
    }
}

extension WelcomeViewController: LFLiveSessionDelegate {
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("State: \(state.hashValue)")
        switch state {
            case LFLiveState.ready:
                break
            case LFLiveState.pending:
                self.connectButton.animateAlpha()
                self.loadingView.startAnimating()
                break
            case LFLiveState.start:
                print("Ready to start")
                break
            case LFLiveState.error:
                if (self.sessionState != .error) {
                    self.sessionState = .error
                    self.loadingView.stopAnimating()
                    self.connectButton.animateAlpha()
                }
                break
            case LFLiveState.stop:
                break
            default:
                break
        }

    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("Error: \(errorCode.rawValue)")
        var message: String = ""
        switch errorCode.rawValue {
            case 201:
                break
            case 202:
                break
            case 203:
                break
            case 204:
                break
            case 205:
                break
            default:
                break
        }
        AlertHelper.getInstance().show("Error", message: "Failed to connect. Please check availability of Ant Media Server")
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("Debug info: \(debugInfo.debugDescription)")
    }
}
