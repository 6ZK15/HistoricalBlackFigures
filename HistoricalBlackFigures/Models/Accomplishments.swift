//
//  Accomplishments.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/10/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation

struct Accomplishments {
    fileprivate var _accomplishment: String!
    fileprivate var _accomplishmentKey: String!
    
    var accomplishment: String {
        return _accomplishment
    }
    
    var accomplishmentKey: String {
        return _accomplishmentKey
    }
    
    // Initialize the new Accomplishment
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._accomplishmentKey = key
        
        if let accomplishment = dictionary["accomplishments"] as? String {
            self._accomplishment = accomplishment
        }
    }
}
