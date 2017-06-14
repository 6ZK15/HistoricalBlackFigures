//
//  HomeViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/9/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lifeSpan: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var subTitle: UILabel!
    
    // Declare Classes
    
    // Declare Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getListOfFigures()
        
        checkForiPhoneSize()
        setHBFTitle()
        setHBFPhoto()
        setCurrentDate()
        
        // DispatchQueue.global(qos: .default).async(execute: {() -> Void in
        //     self.startTimer()
        // })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHBFTitle() {
        
    }
    
    func setHBFPhoto() {
        
    }
    
    func setCurrentDate() {
        var components: DateComponents? = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let day: Int = (components?.day)!
        let month: Int = (components?.month)!
        let year: Int = (components?.year)!
        datelabel.text = "\(Int(month)).\(Int(day)).\(Int(year))"
        print("Date: ", datelabel)
    }
    
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
    
    func setSearchBarContentList() {
        
    }
    
    func searchTableList() {
        
    }
    
    func checkForiPhoneSize() {
        let mainScreenHeight: Int = Int(UIScreen.main.bounds.size.height)
        let mainScreenWidth: Int = Int(UIScreen.main.bounds.size.width)
        //iPhone Plus
        if (mainScreenHeight == 736) && (mainScreenWidth == 414) {
            print("iPhone 6/7 Plus")
        }
        else if (mainScreenHeight == 667) && (mainScreenWidth == 375) {
            print("iPhone 6/7")
        }
        else if (mainScreenHeight == 568) && (mainScreenWidth == 320) {
            print("iPhone 5/SE")
        }
    }
    
    // MARK: - UITableView Delegate/DataSource
    
    
    // MARK: - UISearchBarDelegate / UISearchDisplayDelegate
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
