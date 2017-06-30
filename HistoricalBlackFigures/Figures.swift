//
//  Figures.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/10/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation

struct Figures {
    
    fileprivate var _accomplishments: [String]!
    fileprivate var _figuresKey: String!
    fileprivate var _lifeSpan: String!
    fileprivate var _lifeSummary: String!
    
    var accomplishments: [String] {
        return _accomplishments
    }
    
    var figuresKey: String {
        return _figuresKey
    }
    
    var lifeSpan: String {
        return _lifeSpan
    }
    
    var lifeSummary: String {
        return _lifeSummary
    }
    
    // Initialize the new Post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._figuresKey = key
        
        if let lifeSpan = dictionary["lifeSpan"] as? String {
            self._lifeSpan = lifeSpan
        }
        
        if let lifeSummary = dictionary["lifeSummary"] as? String {
            self._lifeSummary = lifeSummary
        }
        
        if let accomplishments = dictionary["accomplishments"] as? [String] {
            self._accomplishments = accomplishments
        }
    }
}
