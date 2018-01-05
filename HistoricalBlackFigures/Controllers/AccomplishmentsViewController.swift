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

class AccomplishmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // @IBOutlet
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    var accomplishmentsArray = [String]()
    var numberOfAccomplishments: Int = 0

    
    // Declare Variables
    var databaseReference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfAccomplishments()
        adjustBackBtn()
        checkForSearchedFigure()
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
    
    func setHBFTitle() {
        databaseReference = FIRDatabase.database().reference()
        let figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        subTitle.text = figureKey
    }
    
    @objc func backPressed() {
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
    
    func checkForSearchedFigure() {
        var viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            print("Presenting View Controller objectAtIndex: \(viewControllers?[0].self ?? "error")")
            bg.image = UIImage(named: "bgA2.png")
        }
        else if viewControllers?.count == 2 {
            print("Presenting View Controller objectAtIndex: \(viewControllers?[1].self ?? "error")")
            bg.image = UIImage(named: "bgA.png")
        }
    }
    
    func getListOfAccomplishments() {
        databaseReference = FIRDatabase.database().reference()
        let figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        databaseReference.child(figureKey).child("accomplishments").observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in snapshots {
                    let snap = child.value as! String
                    self.accomplishmentsArray.insert(snap, at: 0)
                }
                self.numberOfAccomplishments = self.accomplishmentsArray.count
            }
        })
    }
    
    // MARK: - UITableView Delegate/DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewControllers: [Any]? = navigationController?.viewControllers
        var numberOfRows = Int()

        if viewControllers?.count == 3 {
            numberOfRows = UserDefaults.standard.value(forKey: "searchedNumberOfAccomplishments") as! Int
        } else if viewControllers?.count == 2 {
            numberOfRows = UserDefaults.standard.value(forKey: "numberOfAccomplishments") as! Int
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.sizeToFit()
        databaseReference = FIRDatabase.database().reference()
        let figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        databaseReference.child(figureKey).child("accomplishments").observeSingleEvent(of: FIRDataEventType.value) { (snapshot) in
            for child in (snapshot.children.allObjects as? [FIRDataSnapshot])! {
                print(child.childrenCount)
                let snap = child.value as! String
                self.accomplishmentsArray.insert(snap, at: 0)
                cell.textLabel?.text = self.accomplishmentsArray[indexPath.row]
                print(self.accomplishmentsArray.count)
                self.numberOfAccomplishments = self.accomplishmentsArray.count
            }
        }
        return cell
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
