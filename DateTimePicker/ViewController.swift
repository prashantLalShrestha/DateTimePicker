//
//  ViewController.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeHeader: UILabel!
    @IBOutlet weak var dateHeader: UILabel!
    
    @IBOutlet weak var timePickerView: DTPickerView!
    @IBOutlet weak var datePicker: DTPickerView!
    
    @IBOutlet weak var confirmButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timeHeader.font = AppFont.regularM
        dateHeader.font = AppFont.regularM
        confirmButton.titleLabel?.font = AppFont.boldS
        
        customDateTimePicker()
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        let date = datePicker.getSelected()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        let dateString = dateformatter.string(from: date)
        let time = timePickerView.getSelected()
        dateformatter.dateFormat = "HH:mm"
        let timeString = dateformatter.string(from: time)
        let alert = UIAlertController(title: "Pick-Up Time", message: "\(timeString)\n\(dateString)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController {
    
    func customDateTimePicker() {
        datePicker.yearRange(inBetween: 1990, end: 2022)
        datePicker.dtType = .date
        datePicker.thirdRowIsHidden = true
        datePicker.bgColor = UIColor.init(white: 1.0, alpha: 0.1)
        datePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.6)
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .clear
        datePicker.selectedTextColor = .white
        datePicker.intialDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        
        timePickerView.dtType = .time
        timePickerView.bgColor = UIColor.init(white: 1.0, alpha: 0.1)
        timePickerView.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.6)
        timePickerView.deselectedBgColor = .clear
        timePickerView.selectedBgColor = .clear
        timePickerView.selectedTextColor = .white
        timePickerView.intialDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }

}
