//
//  HomeViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/9/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import UserNotifications

class HomeViewController: UIViewController, UISearchResultsUpdating, UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // @IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lifeSpan: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTVbottomBounds: NSLayoutConstraint!
    @IBOutlet weak var subTitle: UILabel!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    var figures = [Figures]() {
        didSet{
            self.searchTableView.reloadData()
        }
    }
    var filteredFigures = [Figures]()
    var randomFigure = Int()
    var randomFigureIndex = Int()
    var badegeCount = 0
    
    // Declare Variables
    var databaseReference: DatabaseReference!
    var searchedSubTitle: String!
    var isSearching = Bool()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfFigures()
        checkForiPhoneSize()
        figuresOperations.setCurrentDate(datelabel: datelabel)
        setSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getListOfFigures() {
        databaseReference = Database.database().reference()
        let randomFigureIndex = UserDefaults.standard.integer(forKey: "randomFigureIndex")
        
        databaseReference.child("_random").observe(DataEventType.value, with: {
            (snapshot) in
            UserDefaults.standard.set(snapshot.value as! Int, forKey: "randomFigure")
            self.randomFigure = snapshot.value as! Int
        })
        
        databaseReference.observe(DataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var tempArray = [Figures]()
                for snap in snapshots {
                    if let figureDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let figure = Figures(key: key, dictionary: figureDictionary)
                        tempArray.append(figure)
                    }
                    self.figures = tempArray
                }
            }
            self.randomFigureIndex = UserDefaults.standard.integer(forKey: "randomFigureIndex")
            self.subTitle.text = self.figures[self.randomFigureIndex].figuresKey
            self.lifeSpan.text = self.figures[self.randomFigureIndex].lifeSpan
            UserDefaults.standard.set(self.figures[self.randomFigureIndex].accomplishments.count, forKey: "numberOfAccomplishments")
            UserDefaults.standard.setValue(self.figures[self.randomFigureIndex].figuresKey, forKey: "figureKey")
            UserDefaults.standard.setValue(self.figures[self.randomFigureIndex].figuresKey, forKey: "figureOfTheDay")
            self.checkUserSettings()
        })
    }
    
    func checkUserSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print(settings.authorizationStatus)
            if(settings.authorizationStatus == .authorized) {
                print("Authorized")
            } else {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted, error) in
                    if let error = error {
                        print(error)
                    } else {
                        
                    }
                })
            }
        }
    }
    
    func checkForiPhoneSize() {
        let mainScreenHeight: Int = Int(UIScreen.main.bounds.size.height)
        let mainScreenWidth: Int = Int(UIScreen.main.bounds.size.width)
        print("mainScreenWidth: \(mainScreenWidth) & mainScreenHeight: \(mainScreenHeight)")
        
        if (mainScreenHeight == 736) && (mainScreenWidth == 414) {
            print("iPhone 6/7/8 Plus")
        } else if (mainScreenHeight == 667) && (mainScreenWidth == 375) {
            print("iPhone 6/7/8 or iPad 12.9")
        } else if (mainScreenHeight == 568) && (mainScreenWidth == 320) {
            print("iPhone 5/SE")
        } else if (mainScreenHeight == 812) && (mainScreenWidth == 375) {
            print("iPhone X")
        } else if (mainScreenHeight == 480) && (mainScreenWidth == 320) {
            print("iPad 9.7 or iPad 10.5")
            lifeSpan.bounds.origin.y = lifeSpan.bounds.origin.y + 24
            containerView.bounds.origin.y = containerView.bounds.origin.y + 30
        }
    }
    
    // MARK: - UITableView Delegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFigures.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! SearchTableViewCell
        let figure: Figures
        
        if searchController.isActive && searchController.searchBar.text != "" {
            figure = filteredFigures[indexPath.row]
            cell.isHidden = false
        } else {
            figure = figures[indexPath.row]
        }
        
        cell.configureCell(figure)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarCancelButtonClicked(searchController.searchBar)
        _ = searchTableView.indexPathForSelectedRow!
    }
    
    // MARK: - UISearchBarDelegate / UISearchDisplayDelegate
    
    func setSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchTableView.tableHeaderView = searchController.searchBar
        searchTableView.tableHeaderView?.backgroundColor = UIColor.clear
        
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.view.backgroundColor = UIColor.clear
        searchController.searchBar.tintColor = UIColor.brown
        searchController.searchBar.barTintColor = UIColor.clear
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchController.dimsBackgroundDuringPresentation = false
        
        searchTableView.isScrollEnabled = false
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFigures = figures.filter({( figure : Figures) -> Bool in
            return figure.figuresKey.lowercased().contains(searchText.lowercased())
        })
        searchTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableView.isScrollEnabled = true
        containerView.alpha = 0
        gradientView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.searchTableView.transform = CGAffineTransform.init(translationX: 0, y: 0 - searchBar.frame.size.height)
            self.searchTableView.frame.size.height = self.searchTableView.frame.size.height + searchBar.frame.size.height
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTableView.isScrollEnabled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTableView.isScrollEnabled = false
        searchController.isActive = false
        searchController.searchBar.isHidden = false
        containerView.alpha = 1
        gradientView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.searchTableView.transform = .identity
        })
    }
    
    func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "svcSegue" {
            if let svc = segue.destination as? SearchedViewController {
                let indexPath = searchTableView.indexPathForSelectedRow
                let selectedRow = indexPath?.row
                let lvc = LifeSummaryViewController()
                lvc.isSearchedFigured = true
                let cell = searchTableView.cellForRow(at: indexPath!) as! SearchTableViewCell
                lvc.subTitleText = cell.figures.figuresKey
                let figureKey = cell.figures.figuresKey
                lvc.bioText = cell.figures.lifeSummary
                UserDefaults.standard.setValue(figureKey, forKey: "figureKey")
                UserDefaults.standard.set(filteredFigures[selectedRow!].accomplishments.count, forKey: "searchedNumberOfAccomplishments")
                UserDefaults.standard.set(randomFigureIndex, forKey: "randomFigureIndex")
                UserDefaults.standard.set(filteredFigures[selectedRow!].figuresKey, forKey: "searchedFigureKey")
                svc.subTitleText = filteredFigures[selectedRow!].figuresKey
                svc.lifeSpanText = filteredFigures[selectedRow!].lifeSpan
            }
        }
    }
}
