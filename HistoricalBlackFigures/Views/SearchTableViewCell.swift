//
//  SearchTableViewCell.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/15/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var figures: Figures!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ figure: Figures) {
        self.figures = figure
        self.textLabel?.text = figure.figuresKey
    }

}
