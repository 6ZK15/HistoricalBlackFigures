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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    var hvc = HomeViewController()
    var fvc = FactsViewController()
    var lvc = LifeSummaryViewController()
    var avc = AccomplishmentsViewController()
    
    var figures = [Figures]()

    
    // Declare Variables
    var subTitleText: String? = nil
    var lifeSpanText: String? = nil
    var accomplishments:String? = nil
    var databaseReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfFigures()
        dateLabel.isHidden = true
        subTitle.text = subTitleText
        lifeSpan.text = lifeSpanText
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
        
        let mainScreenHeight: Int = Int(UIScreen.main.bounds.size.height)
        let mainScreenWidth: Int = Int(UIScreen.main.bounds.size.width)
        if (mainScreenHeight == 480) && (mainScreenWidth == 320) {
            print("iPad 9.7 or iPad 10.5")
            containerView.bounds.origin.y = containerView.bounds.origin.y + 30
            containerView.frame.size.height = containerView.frame.size.height + 30
            containerViewConstraint.constant = 40
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
        let randomFigureIndex = UserDefaults.standard.integer(forKey: "randomFigureIndex")
        UserDefaults.standard.setValue(figures[randomFigureIndex].figuresKey, forKey: "figureKey")
        hvc.viewWillAppear(true)
    }
    
    func getListOfFigures() {
        databaseReference = Database.database().reference()
        let hvc = HomeViewController()
        databaseReference.child("_random").observe(DataEventType.value, with: {
            (snapshot) in
            UserDefaults.standard.set(snapshot.value as! Int, forKey: "randomFigure")
            hvc.randomFigure = snapshot.value as! Int
        })
        databaseReference.observe(DataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let figureDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let figure = Figures(key: key, dictionary: figureDictionary)
                        self.figures.append(figure)
                    }
                }
            }
        })
    }
}
