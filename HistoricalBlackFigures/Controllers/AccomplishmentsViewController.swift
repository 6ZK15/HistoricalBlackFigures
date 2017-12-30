//
//  AccomplishmentsViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/19/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AccomplishmentsViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    
    // Declare Variables
    var databaseReference: FIRDatabaseReference!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity = Entity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBackBtn()
//      getData()
        setHBFTitle()
        figuresOperations.setCurrentDate(datelabel: dateLabel)
        
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        do {
            try context.fetch(Entity.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    func setHBFTitle() {
        databaseReference = FIRDatabase.database().reference()
        let figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        subTitle.text = figureKey
    }
    
    func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func adjustBackBtn() {
        let mainScreenHeight: Int = Int(UIScreen.main.bounds.size.height)
        let mainScreenWidth: Int = Int(UIScreen.main.bounds.size.width)
        if (mainScreenHeight == 736) && (mainScreenWidth == 414) {
            print("iPhone 6/7 Plus")
        } else if (mainScreenHeight == 667) && (mainScreenWidth == 375) {
            print("iPhone 6/7")
        } else if (mainScreenHeight == 568) && (mainScreenWidth == 320) {
            print("iPhone 5/SE")
            backBtnTopConstraint.constant = 8
            backBtnWidthConstraint.constant = 12
            backBtnHeightConstraint.constant = 24
            backBtn.updateConstraints()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
