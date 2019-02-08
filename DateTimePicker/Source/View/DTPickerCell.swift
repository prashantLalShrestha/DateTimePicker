//
//  DTPickerCell.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import UIKit

class DTPickerCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.adjustsFontSizeToFitWidth = true
    }

}


extension DTPickerCell {
    
    func selectedCell(textColor: UIColor){
        self.backgroundColor = .clear
        self.dateLabel.textColor = textColor
        self.alpha = 1
        bottomBorder.backgroundColor = textColor
    }
    
    func deSelectCell(bgColor: UIColor, textColor: UIColor){
        self.backgroundColor = bgColor
        self.dateLabel.textColor = textColor
        bottomBorder.backgroundColor = bgColor
        self.alpha = 0.5
    }
    
}
