//
//  HelpViewController.swift
//  RTMP Ref App
//
//  Created by Oğulcan on 5.12.2018.
//  Copyright © 2018 AntMedia. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextLinks()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setTextLinks() {
        
    }
}
