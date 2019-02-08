//
//  RadiusButton.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
}
