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
    
    // Declare Variables
    var databaseReference: FIRDatabaseReference!
    
    var isSearching = Bool()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //getListOfFigures()
        setHBFTitle()
        checkForiPhoneSize()
        updateBlackFigure()
        
        figuresOperations.setCurrentDate(datelabel: datelabel)
        setSearchController()
        
        // DispatchQueue.global(qos: .default).async(execute: {() -> Void in
        //     self.startTimer()
        // })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHBFTitle() {
        subTitle.text = UserDefaults.standard.string(forKey: "subTitle")
        lifeSpan.text = UserDefaults.standard.string(forKey: "lifeSpan")
        
        // Stores figure name in data model
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entitiy = Entity(context: context)
        entitiy.name = subTitle.text
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getListOfFigures() {
        databaseReference = FIRDatabase.database().reference()
        databaseReference.observe(FIRDataEventType.value, with: {
            (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let figureDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let figure = Figures(key: key, dictionary: figureDictionary)
                        self.figures.insert(figure, at: 0)
                    }
                }
                
                //Loop through figures dictionary. Select Random figure.
                //Another Idea I was thinking was to loop through firebase and select a figure. Only thing i'm not sure about is that the random function will accept
               
                /*
                for i in 0..<self.figures.count {
                    //Use random function to randomly select a figure
                    let randomFigure = Int(arc4random_uniform(UInt32(self.figures.count)))
                    UserDefaults.standard.set(self.figures[randomFigure].figuresKey, forKey: "subTitle")
                    UserDefaults.standard.set(self.figures[randomFigure].lifeSpan, forKey: "lifeSpan")
                    UserDefaults.standard.set(self.figures[randomFigure].lifeSummary, forKey: "lifeSummary")
                    UserDefaults.standard.set(self.figures[randomFigure].accomplishments, forKey: "accomplishments")
                    
                    //print the figure firebase's index
                    print("Random Figure Number: ", randomFigure)
                    self.viewDidLoad()
                    self.viewWillAppear(true)
                }
 */
                
            
 
                //THIS METHOD LOOPS THROUGH MORE BUT IT ENDED UP CRASHING TOO
                
                let index1 = Int(self.figures.count)
                let randomFigure = Int(arc4random_uniform(UInt32(index1)))
                UserDefaults.standard.set(self.figures[randomFigure].figuresKey, forKey: "subTitle")
                UserDefaults.standard.set(self.figures[randomFigure].lifeSpan, forKey: "lifeSpan")
                UserDefaults.standard.set(self.figures[randomFigure].lifeSummary, forKey: "lifeSummary")
                UserDefaults.standard.set(self.figures[randomFigure].accomplishments, forKey: "accomplishments")
                
               print("Random Figure Number: ", randomFigure)
                self.viewDidLoad()
                self.viewWillAppear(true)
            }
            //print("List of figures: ", self.figures)
            
        })
    }
    
    //FUNC JUST TO SEE IF THEE FIGURE CHANGES every 5 seconds. if it works just use it to put in amount of seconds in a day to update hbf
        func updateBlackFigure() {
        var timer = Timer()
        var counter = 0
        
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.getListOfFigures), userInfo: nil, repeats: true)
            

            
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
        performSegue(withIdentifier: "svcSegue", sender: indexPath)
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
    }
    
    func setSearchBarContentList() {
    }
    
    func searchTableList() {
        
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
        containerView.alpha = 1
        gradientView.isHidden = true
    }
    
    func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
