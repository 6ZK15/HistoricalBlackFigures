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
    
    // @IBOutlets
    @IBOutlet weak var accomplishmentsTableView: UITableView!
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
    var accomplishments = [Accomplishments]()
    
    // Declare Variables
    var databaseReference: FIRDatabaseReference!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var entity = Entity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustBackBtn()
        checkForSearchedFigure()
//      getData()
        setHBFTitle()
        figuresOperations.setCurrentDate(datelabel: dateLabel)
        getListOfAccomplishments()
        
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getData() {
//        do {
//            try context.fetch(Entity.fetchRequest())
//        } catch {
//            print("Fetching Failed")
//        }
//    }
    
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
            // subTitle.text = UserDefaults.standard.object(forKey: "SearchDataSubtitle")
            // setSearchedBioTextView()
        }
        else if viewControllers?.count == 2 {
            print("Presenting View Controller objectAtIndex: \(viewControllers?[1].self ?? "error")")
            bg.image = UIImage(named: "bgA.png")
            // subTitle.text = UserDefaults.standard.object(forKey: "historicalFigure")
            // setBioTextView()
        }
    }
    
    func getListOfAccomplishments() {
        
        let figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        print("This is the figure for accomplishments: ", figureKey)
        
        databaseReference.child(figureKey).child("accomplishments").observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("snap of accomplishment: ", snap.value!)
                    
                    
                    
                    if let accomplishmentsDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let accomplishment = Accomplishments(key: key, dictionary: accomplishmentsDictionary)
                        self.accomplishments.insert(accomplishment, at: 0)
                        print("List of accomplishments: ", self.accomplishments)
                    }
                }
            }
        })
    }
    
    // MARK: - UITableView Delegate/DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accomplishments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        databaseReference = FIRDatabase.database().reference()
        
        let figureKey = UserDefaults.standard.string(forKey: "figureKey")!
        
        databaseReference.child(figureKey).child("accomplishments").observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let friendDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let acc = Accomplishments(key: key, dictionary: friendDictionary)
                        self.accomplishments.insert(acc, at: 0)
                        cell.textLabel?.text = self.accomplishments[indexPath.row].accomplishment
                    }
                }
                print("List of accomplishments: ", self.accomplishments)
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
