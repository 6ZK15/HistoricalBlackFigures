//
//  SearchedViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/19/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase

class SearchedViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var lifeSpan: UILabel!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    
    // Declare Variables
    var subTitleText: String? = nil
    var lifeSpanText: String? = nil
    var accomplishments:String? = nil
    var databaseReference: FIRDatabaseReference!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.isHidden = true
        subTitle.text = subTitleText
        lifeSpan.text = lifeSpanText
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
        let hvc = HomeViewController()
        print(hvc.randomFigure)
        hvc.viewWillAppear(true)
        getListOfFigures()
    }
    func getListOfFigures() {
        databaseReference = FIRDatabase.database().reference()
        let hvc = HomeViewController()
        
        databaseReference.child("_random").observe(FIRDataEventType.value, with: {
            (snapshot) in
            UserDefaults.standard.set(snapshot.value as! Int, forKey: "randomFigure")
            print("Random Figure: ", snapshot.value as! Int)
            hvc.randomFigure = snapshot.value as! Int
        })
        
        databaseReference.observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let figureDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let figure = Figures(key: key, dictionary: figureDictionary)
                        hvc.figures.append(figure)
                    }
                }
            }
            print("List of figures: ", hvc.figures)
            self.subTitle.text = hvc.figures[hvc.randomFigure].figuresKey
            self.lifeSpan.text = hvc.figures[hvc.randomFigure].lifeSpan
            UserDefaults.standard.setValue(hvc.figures[hvc.randomFigure].figuresKey, forKey: "figureKey")
            //            let lvc = LifeSummaryViewController()
            //            lvc.isSearchedFigured = false
        })
    }
    
}
