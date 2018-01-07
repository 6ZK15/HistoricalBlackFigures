//
//  TableViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/11/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var lsImageView: UIImageView!
    @IBOutlet weak var lsLabel: UILabel!
    @IBOutlet weak var aImageView: UIImageView!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var fImageView: UIImageView!
    @IBOutlet weak var fLabel: UILabel!
    @IBOutlet weak var gImageView: UIImageView!
    @IBOutlet weak var gLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustTableCells()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustTableCells() {
        let mainScreenHeight: Int = Int(UIScreen.main.bounds.size.height)
        let mainScreenWidth: Int = Int(UIScreen.main.bounds.size.width)
        //iPhone Plus
        if (mainScreenHeight == 736) && (mainScreenWidth == 414) {
            
        } else if (mainScreenHeight == 667) && (mainScreenWidth == 375) {
            
        } else if (mainScreenHeight == 568) && (mainScreenWidth == 320) {
            lsImageView.frame = CGRect(x: CGFloat(88), y: CGFloat(8), width: CGFloat(25), height: CGFloat(25))
            lsLabel.frame = CGRect(x: CGFloat(120), y: CGFloat(0), width: CGFloat(129), height: CGFloat(30))
            lsLabel.font = UIFont(name: "WRESTLEMANIA", size: CGFloat(26))
            lsLabel.adjustsFontSizeToFitWidth = true
            aImageView.frame = CGRect(x: CGFloat(125), y: CGFloat(8), width: CGFloat(25), height: CGFloat(25))
            aLabel.frame = CGRect(x: CGFloat(153), y: CGFloat(0), width: CGFloat(110), height: CGFloat(30))
            aLabel.font = UIFont(name: "WRESTLEMANIA", size: CGFloat(24))
            aLabel.adjustsFontSizeToFitWidth = true
            fImageView.frame = CGRect(x: CGFloat(153), y: CGFloat(8), width: CGFloat(25), height: CGFloat(25))
            fLabel.frame = CGRect(x: CGFloat(186), y: CGFloat(0), width: CGFloat(40), height: CGFloat(30))
            fLabel.font = UIFont(name: "WRESTLEMANIA", size: CGFloat(26))
            fLabel.adjustsFontSizeToFitWidth = true
            gImageView.frame = CGRect(x: CGFloat(148), y: CGFloat(4), width: CGFloat(30), height: CGFloat(30))
            gLabel.frame = CGRect(x: CGFloat(181), y: CGFloat(0), width: CGFloat(40), height: CGFloat(30))
            gLabel.font = UIFont(name: "WRESTLEMANIA", size: CGFloat(28))
            gLabel.adjustsFontSizeToFitWidth = true
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
