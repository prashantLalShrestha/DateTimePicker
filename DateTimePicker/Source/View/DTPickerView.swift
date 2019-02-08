//
//  DTPickerView.swift
//  DateTimePicker
//
//  Created by Prashant Shrestha on 2/8/19.
//  Copyright © 2019 Prashant Shrestha. All rights reserved.
//

import UIKit

class DTPickerView: UIView {
    
    enum DTType {
        case time
        case date
    }

    @IBOutlet weak var firstRow: UICollectionView!
    @IBOutlet weak var secondRow: UICollectionView!
    @IBOutlet weak var thirdRow: UICollectionView!
    @IBOutlet var dtView: UIView!
    
    private var years = ModelDate.getYears()
    private let months = ModelDate.getMonths()
    private var currentDay = "31"
    private var days:[ModelDate] = []
    private let hours = ModelDate.getHours()
    private let minutes = ModelDate.getMinutes()
    var infiniteScrollingBehaviourForFirstRow: InfiniteScrollingBehaviour!
    var infiniteScrollingBehaviourForSecondRow: InfiniteScrollingBehaviour!
    var infiniteScrollingBehaviourForThirdRow: InfiniteScrollingBehaviour!
    
    
    // Accessible Properties
    public var dtType: DTType = .date {
        didSet {
            self.willMove(toSuperview: self.superview)
        }
    }
    
    public var bgColor: UIColor = #colorLiteral(red: 0.5568627451, green: 0.7529411765, blue: 0.6588235294, alpha: 1)
    public var selectedBgColor: UIColor = .white
    public var selectedTextColor: UIColor = .white
    public var deselectedBgColor: UIColor = .clear
    public var deselectTextColor: UIColor = UIColor.init(white: 1.0, alpha: 0.7)
    public var fontFamily: UIFont = UIFont(name: "Nunito-Regular", size: 30)!
    public var fontFamily2: UIFont = UIFont(name: "Nunito-Regular", size: 25)!
    public var intialDate:Date = Date()
    
    var thirdRowIsHidden: Bool = true
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadinit()
        registerCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadinit()
        registerCell()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        days = ModelDate.getDays(years, months)
        
        let configuration = CollectionViewConfiguration(layoutType: .fixedSize(sizeValue: UIScreen.main.bounds.width / 5, lineSpacing: 0), scrollingDirection: .horizontal)
        switch dtType {
        case .date:
            infiniteScrollingBehaviourForSecondRow = InfiniteScrollingBehaviour(withCollectionView: secondRow, andData: months, delegate: self, configuration: configuration)
            infiniteScrollingBehaviourForFirstRow = InfiniteScrollingBehaviour(withCollectionView: firstRow, andData: days, delegate: self, configuration: configuration)
            if !thirdRowIsHidden {
                infiniteScrollingBehaviourForThirdRow = InfiniteScrollingBehaviour(withCollectionView: thirdRow, andData: years, delegate: self, configuration: configuration)
            } else {
                thirdRow.isHidden = true
            }
        case .time:
            infiniteScrollingBehaviourForSecondRow = InfiniteScrollingBehaviour(withCollectionView: secondRow, andData: minutes, delegate: self, configuration: configuration)
            infiniteScrollingBehaviourForFirstRow = InfiniteScrollingBehaviour(withCollectionView: firstRow, andData: hours, delegate: self, configuration: configuration)
            thirdRowIsHidden = true
            thirdRow.isHidden = true
        }
    }
    
    private func loadinit(){
        let bundle = Bundle(for: self.classForCoder)
        bundle.loadNibNamed("DTPickerView", owner: self, options: nil)
        addSubview(dtView)
        dtView.frame = self.bounds
        delay(0.1){
            self.initialDate(date: self.intialDate)
            self.dtView.backgroundColor = self.bgColor
        }
    }
    
    func initialDate(date: Date){
        switch dtType {
        case .date:
            let (mm,dd,yyyy) = date.seprateDateInDDMMYY
            let y = years.index { (modelObj) -> Bool in
                return modelObj.type == yyyy
            }
            
            let d = days.index { (modelObj) -> Bool in
                return Int(modelObj.type) == Int(dd)
            }
            
            let m = Int(mm)! - 1
            
            years[y!].isSelected = true
            months[m].isSelected = true
            days[d!].isSelected = true
            currentDay = "\(days.count)"
            
            if !thirdRowIsHidden {
                collectionState(infiniteScrollingBehaviourForThirdRow, y!)
            }
            
            collectionState(infiniteScrollingBehaviourForSecondRow, m)
            collectionState(infiniteScrollingBehaviourForFirstRow, d!)
        case .time:
            let (HH,mm) = date.seprateDateInHHMM
            let newMinuteValue = (Int(Int(mm)! / 5) * 5) + 5
            let h = hours.index { (modelObj) -> Bool in
                return Int(modelObj.type) == (newMinuteValue < 60 ? Int(HH) : Int(HH)! + 1)
            }
            let m = minutes.index { (modelObj) -> Bool in
                return Int(modelObj.type) == (newMinuteValue < 60 ? newMinuteValue : 0)
            }
            
            hours[h!].isSelected = true
            minutes[m!].isSelected = true
            
            collectionState(infiniteScrollingBehaviourForFirstRow, h!)
            collectionState(infiniteScrollingBehaviourForSecondRow, m!)
        }
        
        
    }
    
    private func collectionState(_ collectionView: InfiniteScrollingBehaviour, _ index: Int) {
        let indexPathForFirstRow = IndexPath(row: index, section: 0)
        switch dtType {
        case .date:
            switch collectionView.collectionView.tag {
            case 0:
                self.days[indexPathForFirstRow.row].isSelected = true
                infiniteScrollingBehaviourForFirstRow.reload(withData: days)
                break
            case 1:
                self.months[indexPathForFirstRow.row].isSelected = true
                infiniteScrollingBehaviourForSecondRow.reload(withData: months)
                break
            case 2:
                self.years[indexPathForFirstRow.row].isSelected = true
                infiniteScrollingBehaviourForThirdRow.reload(withData: years)
                break
            default:
                break
            }
        case .time:
            switch collectionView.collectionView.tag {
            case 0:
                self.hours[indexPathForFirstRow.row].isSelected = true
                infiniteScrollingBehaviourForFirstRow.reload(withData: hours)
                break
            case 1:
                self.minutes[indexPathForFirstRow.row].isSelected = true
                infiniteScrollingBehaviourForSecondRow.reload(withData: minutes)
                break
            default:
                break
            }
        }
        collectionView.scroll(toElementAtIndex: index)
    }
    
    private func registerCell(){
        let bundle = Bundle(for: self.classForCoder)
        let nibName = UINib(nibName: "DTPickerCell", bundle:bundle)
        firstRow.register(nibName, forCellWithReuseIdentifier: "cell")
        secondRow.register(nibName, forCellWithReuseIdentifier: "cell")
        thirdRow.register(nibName, forCellWithReuseIdentifier: "cell")
    }
}


extension DTPickerView: UICollectionViewDelegate {
    public func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) {
        selectMiddleRow(collectionView: behaviour.collectionView, data: behaviour.dataSetWithBoundary as! [ModelDate])
        switch dtType {
        case .date:
            switch behaviour.collectionView.tag {
            case 0:
                behaviour.reload(withData: days)
            case 1:
                behaviour.reload(withData: months)
                break
            case 2:
                behaviour.reload(withData: years)
            default:
                break
            }
        case .time:
            switch behaviour.collectionView.tag {
            case 0:
                behaviour.reload(withData: hours)
            case 1:
                behaviour.reload(withData: minutes)
                break
            default:
                break
            }
        }
        
    }
    func selectMiddleRow(collectionView: UICollectionView, data: [ModelDate]){
        
        let Row = calculateMedian(array: collectionView.indexPathsForVisibleItems)
        let selectedIndexPath = IndexPath(row: Int(Row), section: 0)
        for i in 0..<data.count {
            if i != selectedIndexPath.row {
                data[i].isSelected = false
            }
        }
        if let cell = collectionView.cellForItem(at: selectedIndexPath) as? DTPickerCell {
            cell.selectedCell(textColor: self.selectedTextColor)
            data[Int(Row)].isSelected = true
            if dtType == .date, collectionView.tag != 0{
                compareDays()
            }
        }
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension DTPickerView {
    
    private func compareDays(){
        let newDays = ModelDate.getDays(years, months)
        if let selectedDay = days.filter({ (modelObject) -> Bool in
            return modelObject.isSelected
        }).first {
            newDays.selectDay(selectedDay: selectedDay)
        }
        days = newDays
        // infiniteScrollingBehaviourForDays.collectionView.reloadSections(IndexSet(integer: 0))
        infiniteScrollingBehaviourForFirstRow.reload(withData: days)
        if Int(currentDay)! > days.count{
            let index = days.count - 1
            days[index].isSelected = true
            currentDay = "\(days.count)"
            infiniteScrollingBehaviourForFirstRow.scroll(toElementAtIndex: index)
        }
    }
    
}

extension DTPickerView : InfiniteScrollingBehaviourDelegate {
    public func configuredCell(collectionView: UICollectionView, forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        let cell = behaviour.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DTPickerCell
        cell.dateLabel.font = fontFamily
        switch dtType {
        case .date:
            switch behaviour.collectionView.tag {
            case 0:
                if let day = data as? ModelDate {
                    if day.isSelected {
                        cell.selectedCell(textColor: selectedTextColor)
                    }else {
                        cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                    }
                    cell.dateLabel.text = day.type
                }
            case 1:
                cell.dateLabel.font = fontFamily2
                if let month = data as? ModelDate {
                    cell.dateLabel.text = month.type
                    if month.isSelected {
                        cell.selectedCell(textColor: selectedTextColor)
                        
                    }else {
                        cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                    }
                }
                
            case 2:
                cell.dateLabel.font = fontFamily2
                if let year = data as? ModelDate {
                    cell.dateLabel.text = year.type
                    if year.isSelected {
                        cell.selectedCell(textColor: selectedTextColor)
                    }else {
                        cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                    }
                }
            default:
                return cell
            }
        case .time:
            switch behaviour.collectionView.tag {
            case 0:
                if let hour = data as? ModelDate {
                    if hour.isSelected {
                        cell.selectedCell(textColor: selectedTextColor)
                    }else {
                        cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                    }
                    cell.dateLabel.text = hour.type
                }
            case 1:
                if let minute = data as? ModelDate {
                    cell.dateLabel.text = minute.type
                    if minute.isSelected {
                        cell.selectedCell(textColor: selectedTextColor)
                        
                    }else {
                        cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                    }
                }
                
            default:
                return cell
            }
        }
        
        
        return cell
    }
    
    
    public func didSelectItem(collectionView: UICollectionView,atIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) {
        if let cell = behaviour.collectionView.cellForItem(at: indexPath) as? DTPickerCell {
            cell.dateLabel.font = fontFamily
            switch dtType {
            case .date:
                if behaviour.collectionView.tag == 0 {
                    for i in 0..<days.count {
                        if i != originalIndex {
                            //                        currentDay = days[i].type
                            days[i].isSelected = false
                        }
                    }
                    currentDay  = days[originalIndex].type
                    days[originalIndex].isSelected = true
                    compareDays()
                    cell.selectedCell(textColor: selectedTextColor)
                } else if behaviour.collectionView.tag == 1 {
                    
                    cell.dateLabel.font = fontFamily2
                    for i in 0..<months.count {
                        if i != originalIndex {
                            months[i].isSelected = false
                        }
                    }
                    months[originalIndex].isSelected = true
                    cell.selectedCell(textColor: selectedTextColor)
                    compareDays()
                    infiniteScrollingBehaviourForSecondRow.reload(withData: months)
                    
                } else {
                    
                    cell.dateLabel.font = fontFamily2
                    for i in 0..<years.count {
                        if i != originalIndex {
                            years[i].isSelected = false
                        }
                    }
                    years[originalIndex].isSelected = true
                    cell.selectedCell(textColor: selectedTextColor)
                    compareDays()
                    infiniteScrollingBehaviourForThirdRow.reload(withData: years)
                }
            case .time:
                if behaviour.collectionView.tag == 0 {
                    for i in 0..<hours.count {
                        if i != originalIndex {
                            hours[i].isSelected = false
                        }
                    }
                    hours[originalIndex].isSelected = true
                    cell.selectedCell(textColor: selectedTextColor)
                    infiniteScrollingBehaviourForFirstRow.reload(withData: hours)
                } else if behaviour.collectionView.tag == 1 {
                    for i in 0..<minutes.count {
                        if i != originalIndex {
                            minutes[i].isSelected = false
                        }
                    }
                    minutes[originalIndex].isSelected = true
                    cell.selectedCell(textColor: selectedTextColor)
                    infiniteScrollingBehaviourForSecondRow.reload(withData: minutes)
                }
            }
            
        }
        behaviour.scroll(toElementAtIndex: originalIndex)
    }
    
}

extension DTPickerView {
    
    public func yearRange(inBetween start: Int, end: Int) {
        years = ModelDate.getYears(startYear: start, endYear: end)
        if !thirdRowIsHidden {
            //            print(yearsRowIsHidden)
            infiniteScrollingBehaviourForThirdRow.reload(withData: years)
        }
        
        //yearRow.reloadData()
    }
    
    public func getSelected() -> Date{
        let date = dtType == .date ? CalendarHelper.getThatDate(days, months, years) : CalendarHelper.getThatTime(hours, minutes)
        return date
    }
}


extension DTPickerView {
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func calculateMedian(array: [IndexPath]) -> Float {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)].row + sorted[(sorted.count / 2) - 1].row)) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2].row)
        }
    }
    
}
