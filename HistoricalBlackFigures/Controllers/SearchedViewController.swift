//
//  SearchedViewController.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/19/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class SearchedViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var lifeSpan: UILabel!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtnHeightConstraint: NSLayoutConstraint!
    
    // Declare Classes
    var figuresOperations = FiguresOperation()
    
    // Declare Variables
    var subTitleText: String? = nil
    var lifeSpanText: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.isHidden = true
        subTitle.text = subTitleText
        lifeSpan.text = lifeSpanText
        
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backPressed() {
        navigationController?.popViewController(animated: true)
        let hvc = HomeViewController()
        hvc.viewWillAppear(true)
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
