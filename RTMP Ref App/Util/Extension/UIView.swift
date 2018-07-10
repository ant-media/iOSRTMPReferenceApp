//
//  UIView.swift
//  RTMP Ref App
//
//  Created by Oğulcan on 10.07.2018.
//  Copyright © 2018 AntMedia. All rights reserved.
//

import UIKit

extension UIView {
    
    public func animateAlpha() {
        if (self.alpha == 0) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
            })
        } else if (self.alpha == 1) {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            })
        }
    }
}
