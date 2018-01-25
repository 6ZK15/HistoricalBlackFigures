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
            gImageView.frame.origin.x = 172
            gLabel.frame.origin.x = 215
            gLabel.adjustsFontSizeToFitWidth = true
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
        } else if (mainScreenHeight == 812) && (mainScreenWidth == 375) {
            gImageView.frame.origin.x = 172
            gLabel.frame.origin.x = 215
            gLabel.adjustsFontSizeToFitWidth = true
        }
    }
}
