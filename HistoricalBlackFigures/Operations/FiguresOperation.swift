//
//  FiguresOperation.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/11/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FiguresOperation: NSObject {
    
    func getListOfFigures() {
        let databaseReference = FIRDatabase.database().reference()
        databaseReference.observe(FIRDataEventType.value, with: {
            (snapshot) in
            print("snpashot", snapshot)
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let figure = snap.value as? String {
                        print("HBF - ", figure)
                    }
                }
            }
        })
    }

}
