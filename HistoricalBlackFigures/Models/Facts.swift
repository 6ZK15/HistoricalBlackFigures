//
//  Facts.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/10/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import Foundation

struct Facts {
    
    fileprivate var _dob: String!
    fileprivate var _dod: String!
    fileprivate var _education: String!
    fileprivate var _factsKey: String!
    fileprivate var _occupation: String!
    fileprivate var _parents: String!
    fileprivate var _pob: String!
    fileprivate var _pod: String!
    
    var dob: String {
        return _dob
    }
    
    var dod: String {
        return _dod
    }
    
    var education: String {
        return _education
    }
    
    var factsKey: String {
        return _factsKey
    }
    
    var occupation: String {
        return _occupation
    }
    
    var parents: String {
        return _parents
    }
    
    var pob: String {
        return _pob
    }
    
    var pod: String {
        return _pod
    }
    
    // Initialize the new Post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._factsKey = key
        
        if let dob = dictionary["dob"] as? String {
            self._dob = dob
        }
        
        if let dod = dictionary["dod"] as? String {
            self._dod = dod
        }
        
        if let education = dictionary["education"] as? String {
            self._education = education
        }
        
        if let occupation = dictionary["occupation"] as? String {
            self._occupation = occupation
        }
        
        if let parents = dictionary["parents"] as? String {
            self._parents = parents
        }
        
        if let pob = dictionary["pob"] as? String {
            self._pob = pob
        }
        
        if let pod = dictionary["pod"] as? String {
            self._pod = pod
        }
    }
}
