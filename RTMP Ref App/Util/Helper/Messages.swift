//
//  Messages.swift
//  RTMP Ref App
//
//  Created by Oğulcan on 11.07.2018.
//  Copyright © 2018 AntMedia. All rights reserved.
//

import Foundation
import LFLiveKit

class Messages {
    
    static func getLocalizedError(with code: LFLiveSocketErrorCode) -> String {
        switch code.rawValue {
            case 201:
                return "Preview failed."
            case 202:
                return "Failed to get streaming information. Please check availability of Ant Media Server."
            case 203:
                return "Failed to connect to the socket. Please check your network."
            case 204:
                return "Verify server failed. Please check server url."
            case 205:
                return "Server timeout. Please check network availability and server variables."
            default:
                return ""
        }
    }
    
}
