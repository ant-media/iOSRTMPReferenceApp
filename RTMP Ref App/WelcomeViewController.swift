//
//  WelcomeViewController.swift
//  RTMP Ref App
//
//  Created by Oğulcan on 8.07.2018.
//  Copyright © 2018 AntMedia. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var actionContainer: UIView! {
        didSet {
            self.actionContainer.alpha = 0
        }
    }
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var serverButton: UIButton! {
        didSet {
//            if let server = Defaults[.server] {
//                if (server.count > 0) {
//                    self.serverButton.setTitle("Server ip: \(server)", for: .normal)
//                }
//            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

