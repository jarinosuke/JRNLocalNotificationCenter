//
//  JRNLocalNotificationCenter.swift
//  DemoApp
//
//  Created by Naoki Ishikawa on 6/29/14.
//  Copyright (c) 2014 jarinosuke. All rights reserved.
//

import Foundation
import UIKit

class JRNLocalNotificationCenter : NSObject {
    var localPushDictionary : Dictionary<String, UILocalNotification>
    var checkRemoteNotificationAvailability : Bool
    
    
    init() {
        self.localPushDictionary = Dictionary();
        self.checkRemoteNotificationAvailability = false;
    }
    
    class var defaultCenter : JRNLocalNotificationCenter
        {
    struct Singleton {
        static let instance = JRNLocalNotificationCenter()
        }
        return Singleton.instance
    }
    
}