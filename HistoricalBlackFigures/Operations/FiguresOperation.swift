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
    
    //Declare Variables
    var databaseDate: String!
    
    // Declare Classes
    var homeVC: HomeViewController!
    
    var databaseReference: FIRDatabaseReference!
    
    func getListOfFigures(figures: [Figures]) {
        var figures = figures
        databaseReference = FIRDatabase.database().reference()
        databaseReference.observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let figureDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let figure = Figures(key: key, dictionary: figureDictionary)
                        figures.insert(figure, at: 0)
                    }
                }
            }
            print("List of figures: ", figures)
        })
    }
    
    func setCurrentDate(datelabel: UILabel) {
        var components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let day: Int = (components?.day)!
        let month: Int = (components?.month)!
        let year: Int = (components?.year)!
        datelabel.text = "\(Int(month)).\(Int(day)).\(Int(year))"
        print("Date: ", datelabel)
        
        databaseReference = FIRDatabase.database().reference()
        databaseReference.child("_currentDate").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.databaseDate = snapshot.value as! String
            print("Database Date value: ", self.databaseDate)
            
            if datelabel.text == (self.databaseDate) {
            
            } else {
                print("Dates do not match")
                print("Current date: ", datelabel.text!)
                self.databaseReference.child("_currentDate").setValue(datelabel.text!)
                
                let randomFigure = arc4random_uniform(6) + 1
                self.databaseReference.child("_random").setValue(randomFigure)
            }
        })
        
        // Stores date in data model
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let entitiy = Entity(context: context)
//        entitiy.date = datelabel.text
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

}
