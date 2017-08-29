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

class HomeViewController: UIViewController, UISearchResultsUpdating, UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // @IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lifeSpan: UILabel!
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var subTitle: UILabel!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    var figures = [Figures]()
    var filteredFigures = [Figures]()
    var randomFigure = Int()
    
    // Declare Variables
    var databaseReference: FIRDatabaseReference!
    var searchedSubTitle: String!
    
    var isSearching = Bool()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfFigures()
        setHBFTitle()
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
    
    func setHBFTitle() {
        // Stores figure name in data model
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entitiy = Entity(context: context)
        entitiy.name = subTitle.text
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getListOfFigures() {
        databaseReference = FIRDatabase.database().reference()
        
        databaseReference.child("_random").observe(FIRDataEventType.value, with: {
            (snapshot) in
            UserDefaults.standard.set(snapshot.value as! Int, forKey: "randomFigure")
            print("Random Figure: ", snapshot.value as! Int)
            self.randomFigure = snapshot.value as! Int
        })
        
        databaseReference.observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let figureDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let figure = Figures(key: key, dictionary: figureDictionary)
                        self.figures.append(figure)
                    }
                }
            }
            print("List of figures: ", self.figures)
            self.subTitle.text = self.figures[self.randomFigure].figuresKey
            self.lifeSpan.text = self.figures[self.randomFigure].lifeSpan
            UserDefaults.standard.set(self.figures[self.randomFigure].figuresKey, forKey: "figureKey")
        })
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
        let indexPath = searchTableView.indexPathForSelectedRow!
        let cell = searchTableView.cellForRow(at: indexPath) as! SearchTableViewCell
        searchedSubTitle = cell.textLabel?.text
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
        containerView.alpha = 0
        gradientView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        searchController.searchBar.isHidden = true
        containerView.alpha = 1
        gradientView.isHidden = true
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
                svc.subTitleText = filteredFigures[selectedRow!].figuresKey
                svc.lifeSpanText = filteredFigures[selectedRow!].lifeSpan
            }
        }
    }
}
