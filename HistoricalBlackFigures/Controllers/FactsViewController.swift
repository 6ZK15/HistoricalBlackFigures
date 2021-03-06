//
//  FactsViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/19/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // @IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var factsTableView: UITableView!
    @IBOutlet weak var subTitle: UILabel!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    var facts = [Facts]()
    
    // Declare Variables
    var databaseReference: DatabaseReference!
    var figureKey: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func getFacts() {
        databaseReference = Database.database().reference()
        let viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            figureKey = UserDefaults.standard.string(forKey: "searchedFigureKey")!
        }
        else if viewControllers?.count == 2 {
            figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        }
        
        databaseReference.child(figureKey!).observe(DataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let factsDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let fact = Facts(key: key, dictionary: factsDictionary)
                        self.facts.insert(fact, at: 0)
                    }
                }
            }
        })
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
    
    func checkForSearchedFigure() {
        let viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            bg.image = UIImage(named: "bgF2.png")
        }
        else if viewControllers?.count == 2 {
            bg.image = UIImage(named: "bgF.png")
        }
    }
    
    // MARK: - UITableView Delegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        databaseReference = Database.database().reference()
        let viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            figureKey = UserDefaults.standard.string(forKey: "searchedFigureKey")!
        }
        else if viewControllers?.count == 2 {
            figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        }
        
        databaseReference.child(figureKey!).observe(DataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let factsDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let fact = Facts(key: key, dictionary: factsDictionary)
                        self.facts.insert(fact, at: 0)
                    }
                }
                
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Date of Birth:"
                    cell.detailTextLabel?.text = self.facts[0].dob
                } else if indexPath.row == 1 {
                    cell.textLabel?.text = "Place of Birth:"
                    cell.detailTextLabel?.text = self.facts[0].pob
                } else if indexPath.row == 2 {
                    cell.textLabel?.text = "Occupation:"
                    cell.detailTextLabel?.text = self.facts[0].occupation
                } else if indexPath.row == 3 {
                    cell.textLabel?.text = "Education:"
                    cell.detailTextLabel?.text = self.facts[0].education
                } else if indexPath.row == 4 {
                    cell.textLabel?.text = "Parents:"
                    cell.detailTextLabel?.text = self.facts[0].parents
                } else if indexPath.row == 5 {
                    cell.textLabel?.text = "Date of Death:"
                    cell.detailTextLabel?.text = self.facts[0].dod
                } else if indexPath.row == 6 {
                    cell.textLabel?.text = "Place of Death:"
                    cell.detailTextLabel?.text = self.facts[0].pod
                }
            }
        })
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
