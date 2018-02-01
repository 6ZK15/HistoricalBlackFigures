//
//  LifeSummaryViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/19/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class LifeSummaryViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet var bannerView: GADBannerView!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    var homeVC: HomeViewController!
    
    // Declare Variables
    var databaseReference: DatabaseReference!
    var subTitleText: String? = nil
    var bioText: String? = nil
    var isSearchedFigured = Bool()
    var figureKey: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBackBtn()
        checkForSearchedFigure()
        setHBFTitle()
        setBioTextView()
        figuresOperations.setCurrentDate(datelabel: dateLabel)
        bioTextView.text = bioText
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHBFTitle() {
        databaseReference = Database.database().reference()
        let viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            figureKey = UserDefaults.standard.string(forKey: "searchedFigureKey")!
        }
        else if viewControllers?.count == 2 {
            figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        }
        subTitle.text = figureKey
    }
    
    func setBioTextView() {
        databaseReference = Database.database().reference()
        let viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            figureKey = UserDefaults.standard.string(forKey: "searchedFigureKey")!
        }
        else if viewControllers?.count == 2 {
            figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        }
        databaseReference.child(figureKey!).child("lifeSummary").observe(DataEventType.value, with: {
            (snapshot) in
            self.bioTextView.text = snapshot.value as! String
        })
    }
    
    func checkForSearchedFigure() {
        let viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            bg.image = UIImage(named: "bgLS2.png")
        }
        else if viewControllers?.count == 2 {
            bg.image = UIImage(named: "bgLS.png")
        }
    }
    
    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func adjustBackBtn() {
        let mainScreenHeight: Int = Int(UIScreen.main.bounds.size.height)
        let mainScreenWidth: Int = Int(UIScreen.main.bounds.size.width)
        if (mainScreenHeight == 736) && (mainScreenWidth == 414) {
            // iPhone 6/7 Plus
        } else if (mainScreenHeight == 667) && (mainScreenWidth == 375) {
            // iPhone 6/7
        } else if (mainScreenHeight == 568) && (mainScreenWidth == 320) {
            // iPhone 5/SE
            backBtnTopConstraint.constant = 8
            backBtnWidthConstraint.constant = 12
            backBtnHeightConstraint.constant = 24
            backBtn.updateConstraints()
        }
    }
}
