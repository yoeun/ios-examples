//
//  KeyHelper.swift
//  ios-experiments
//
//  Created by Yoeun Pen on 8/4/16.
//  Copyright © 2016 Yoeun Pen. All rights reserved.
//

import Foundation

class KeyHelper {
    static let sharedInstance = KeyHelper()
    
    lazy var values: NSDictionary? = {
        let path = NSBundle.mainBundle().pathForResource("Keys", ofType:"plist")
        return NSDictionary(contentsOfFile:path!)
    }()
    
    func get(keyName: String) -> String? {
        return values?.objectForKey(keyName) as? String
    }
}