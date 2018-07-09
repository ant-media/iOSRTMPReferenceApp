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
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.setGesture()
        
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
}

