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
    @IBOutlet weak var helpButton: UIButton! {
        didSet {
            self.helpButton.alpha = 0
        }
    }

    var isVideoGranted: Bool = false
    var isAudioGranted: Bool = false
    var cancellable: SimpleClosure!
    var lastErrorCode: LFLiveSocketErrorCode!
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
                self.helpButton.alpha = 1
                self.view.layoutIfNeeded()
            })
        })
    }
    
    @IBAction func connectButton(_ sender: UIButton ) {
        self.view.endEditing(true)
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
            
            self.cancellable = Run.afterDelay(10, block: {
                if self.session.state == .pending {
                    Run.onMainThread {
                        self.session.stopLive()
                        self.loadingView.stopAnimating()
                        self.connectButton.animateAlpha()
                        AlertHelper.getInstance().show("Error", message: "Server timeout. Please check network availability and server variables.")
                    }
                }
            })
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
    
    private func readyToStart() {
        if isVideoGranted && isAudioGranted {
            Defaults[.room] = roomField.text!
            self.cancellable()
            self.session.stopLive()
            self.lastErrorCode = nil
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Video") as! VideoViewController
            self.present(controller, animated: true, completion: {
                self.loadingView.stopAnimating()
            })
        } else {
            if !isVideoGranted {
                requestAccessForVideo()
                return
            }
            if !isAudioGranted {
                requestAccessForAudio()
            }
        }
    }
    
    private func setGesture() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.toggleContainer))
        self.tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status  {
            case AVAuthorizationStatus.notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if (granted) {
                        DispatchQueue.main.async {
                            self.isVideoGranted = true
                            self.readyToStart()
                        }
                    }
                })
                break
            case AVAuthorizationStatus.authorized:
                print("Video -> Authorized")
                self.isVideoGranted = true
                self.readyToStart()
                break
            case AVAuthorizationStatus.denied, AVAuthorizationStatus.restricted:
                print("Video -> Denied")
                AlertHelper.getInstance().show("Error!", message: "Application can not access camera. Please go to settings and make it enabled")
                break
        }
    }
    
    private func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
            case AVAuthorizationStatus.notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                    if (granted) {
                        DispatchQueue.main.async {
                            self.isAudioGranted = true
                            self.readyToStart()
                        }
                    }
                })
                break
            case AVAuthorizationStatus.authorized:
                print("Audio -> Authorized")
                self.isAudioGranted = true
                self.readyToStart()
                break
            case AVAuthorizationStatus.denied, AVAuthorizationStatus.restricted:
                print("Audio -> Denied")
                AlertHelper.getInstance().show("Error!", message: "Application can not access camera. Please go to settings and make it enabled")
                break
        }
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
                self.readyToStart()
                break
            case LFLiveState.error:
                if (self.sessionState != .error) {
                    self.sessionState = .error
                    self.loadingView.stopAnimating()
                    self.connectButton.animateAlpha()
                }
                break
            case LFLiveState.stop:
                if (self.sessionState != .stop) {
                    self.sessionState = .stop
                    self.loadingView.stopAnimating()
                    self.connectButton.animateAlpha()
                }
                break
            default:
                break
        }
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        if (self.lastErrorCode == nil) {
            self.lastErrorCode = errorCode
            let message: String = Messages.getLocalizedError(with: errorCode)
            AlertHelper.getInstance().show("Error", message: message)
        }
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("Debug info: \(debugInfo.debugDescription)")
    }
}
