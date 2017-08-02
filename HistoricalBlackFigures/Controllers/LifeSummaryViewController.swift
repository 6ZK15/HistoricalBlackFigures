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
    var databaseReference: FIRDatabaseReference!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity = Entity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getData()
        adjustBackBtn()
        checkForSearchedFigure()
        setHBFTitle()
        setBioTextView()
        figuresOperations.setCurrentDate(datelabel: dateLabel)
        loadAd()
        
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAd()
    {
        bannerView.adUnitID = "ca-app-pub-3130282757948775/6590174686"
        bannerView.rootViewController = self
        
        let request: GADRequest = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
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
    
    func setBioTextView() {
        databaseReference = FIRDatabase.database().reference()
        
        let firgureKey = UserDefaults.standard.string(forKey: "figureKey")!
        
        databaseReference.child(firgureKey).child("lifeSummary").observe(FIRDataEventType.value, with: {
            (snapshot) in
            self.bioTextView.text = snapshot.value as! String
        })
        
    }
    
    func checkForSearchedFigure() {
        var viewControllers: [Any]? = navigationController?.viewControllers
        if viewControllers?.count == 3 {
            print("Presenting View Controller objectAtIndex: \(viewControllers?[0].self ?? "error")")
            bg.image = UIImage(named: "bgLS2.png")
            // subTitle.text = UserDefaults.standard.object(forKey: "SearchDataSubtitle")
            // setSearchedBioTextView()
        }
        else if viewControllers?.count == 2 {
            print("Presenting View Controller objectAtIndex: \(viewControllers?[1].self ?? "error")")
            bg.image = UIImage(named: "bgLS.png")
            // subTitle.text = UserDefaults.standard.object(forKey: "historicalFigure")
            // setBioTextView()
        }
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
