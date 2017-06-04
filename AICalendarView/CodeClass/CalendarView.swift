//
//  CalendarView.swift
//  PanoramicAgriculture
//
//  Created by ai on 2017/5/24.
//  Copyright © 2017年 oraro. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate: NSObjectProtocol {
    func getCurrentDate(date: Date)
}

class CalendarView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    weak var delegate: CalendarViewDelegate?
    var calendarCollectionView: UICollectionView?
    private var cellWidth: CGFloat?
    let itemId = "cDPCollectionViewCell"
    private var selectedTag: NSInteger?
    private var isScrollAble: Bool = true
    private var previousDate: Date?
    private var nextDate: Date?
    var currentDate: Date?
//    {
//        willSet
//        {
//            if let date:Date = newValue {
//                currentDateLab?.text = formatterCurrentDate(date: date)
//            }else{
//                currentDateLab?.text = formatterCurrentDate(date: Date())
//            }
//        }
//    }
    
    var previousDatesArr: [DateModel]?
    var currentDatesArr: [DateModel]?
    var nextDateDatesArr: [DateModel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpViews(isScrollEnable: Bool) {
        
        getDates()
        
        let width = Screen_Width - 75
        let height = width * 6.0 / 7.0
        
        cellWidth = width/7
        
        //日历
        let layout = UICollectionViewFlowLayout()
        // 定义大小
        layout.itemSize = CGSize.init(width: cellWidth!, height: cellWidth!)
        // 设置最小行间距
        layout.minimumLineSpacing = 0
        // 设置垂直间距
        layout.minimumInteritemSpacing = 0
        //设置四周间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        // 设置滚动方向（默认水平滚动）
        layout.scrollDirection = UICollectionViewScrollDirection.vertical;
        
        calendarCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        calendarCollectionView?.backgroundColor = UIColor.clear
        calendarCollectionView?.dataSource = self
        calendarCollectionView?.delegate = self
        calendarCollectionView?.register(UINib.init(nibName: "CDPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: itemId)
        calendarCollectionView?.showsVerticalScrollIndicator = false
        //炒鸡重要，这样保证不回弹到顶部
        calendarCollectionView?.scrollsToTop = false
        calendarCollectionView?.isScrollEnabled = isScrollEnable
        isScrollAble = isScrollEnable
        addSubview(calendarCollectionView!)
        
    }
    
    //    MARK: - formatterCurrentDate
    func formatterCurrentDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    
    //    MARK: - 前一个月
    func goPreviousMonth() {
        previousDatesArr?.removeAll()
        currentDatesArr?.removeAll()
        nextDateDatesArr?.removeAll()
        selectedTag = nil
        currentDate = Date().getLastDate(date: currentDate!)
        currentDatesArr = DateManager.dateManager.getDateModels(aDate: currentDate!)
        let previousDate = Date().getLastDate(date: currentDate!)
        previousDatesArr = DateManager.dateManager.getDateModels(aDate: previousDate)
        let nextDate = Date().getNextDate(date: currentDate!)
        nextDateDatesArr = DateManager.dateManager.getDateModels(aDate: nextDate)
        calendarCollectionView?.reloadData()
    }
    
    //    MARK: - 后一个月
    func goNextMonth() {
        previousDatesArr?.removeAll()
        currentDatesArr?.removeAll()
        nextDateDatesArr?.removeAll()
        selectedTag = nil
        currentDate = Date().getNextDate(date: currentDate!)
        currentDatesArr = DateManager.dateManager.getDateModels(aDate: currentDate!)
        let previousDate = Date().getLastDate(date: currentDate!)
        previousDatesArr = DateManager.dateManager.getDateModels(aDate: previousDate)
        let nextDate = Date().getNextDate(date: currentDate!)
        nextDateDatesArr = DateManager.dateManager.getDateModels(aDate: nextDate)
        calendarCollectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CDPCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: itemId, for: indexPath) as! CDPCollectionViewCell
        var dateModel:DateModel
        switch indexPath.section {
        case 0:
            dateModel = (previousDatesArr?[indexPath.row])!
            break
        case 1:
            dateModel = (currentDatesArr?[indexPath.row])!
            break
        default:
            dateModel = (nextDateDatesArr?[indexPath.row])!
            break
        }
        if let day = dateModel.day {//设置日期
            cell.dateLab.setTitle(String(day), for: UIControlState.normal)
        }
        if dateModel.isPrevMonth {//设置字体颜色和各个cell是否能被选中
            if isScrollAble {
                cell.dateLab.setTitleColor(UIColor.clear, for: UIControlState.normal)
            }else{
                cell.dateLab.setTitleColor(ARGBColorFromHex(rgbValue: 0xCDD1F5), for: UIControlState.normal)
            }
            cell.isCanBeSelected = false
        }else if dateModel.isNextMonth {
            if isScrollAble {
                cell.dateLab.setTitleColor(UIColor.clear, for: UIControlState.normal)
            }else{
                cell.dateLab.setTitleColor(ARGBColorFromHex(rgbValue: 0xCDD1F5), for: UIControlState.normal)
            }
            cell.isCanBeSelected = false
        }else{
            cell.dateLab.setTitleColor(UIColor.white, for: UIControlState.normal)
            cell.dateLab.setBackgroundImage(UIImage.init(named: ""), for: UIControlState.normal)
            cell.isCanBeSelected = true
        }
        if selectedTag != nil && selectedTag == indexPath.row{//控制选中颜色
            cell.dateLab.setBackgroundImage(UIImage.init(named: "selectedDate"), for: UIControlState.normal)
        }else{
            
            if dateModel.isToday {
                cell.dateLab.setBackgroundImage(UIImage.init(named: "todaySelected"), for: UIControlState.normal)
            }else{
                cell.dateLab.setBackgroundImage(UIImage.init(named: ""), for: UIControlState.normal)
            }
        }
        //        cell.dateLab.backgroundColor = dateModel.isSelected && selectedTag == indexPath.row ? UIColor.red : UIColor.white
        cell.tag = indexPath.row
        
        if indexPath.section == 0 && indexPath.row == 41 && !isLoaded {
            isLoaded = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: CDPCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CDPCollectionViewCell
        if cell.isCanBeSelected {
            selectedTag = cell.tag
            
            let calendar = Calendar.current
            var com = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from:currentDate!)
            com.day = Int((cell.dateLab.titleLabel?.text)!)
            currentDate = calendar.date(from: com)!
            delegate?.getCurrentDate(date: currentDate!)
        }
        collectionView.reloadData()
    }
    
    private var offsetY: CGPoint = CGPoint.zero
    private var currentSection: NSInteger = 1
    private var isLoaded: Bool = false {
        willSet
        {
            if newValue {
                let indexPath = IndexPath.init(row: 0, section: 1)
                calendarCollectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        offsetY = scrollView.contentOffset
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let height = calendarCollectionView?.bounds.size.height
        var currentIndexPath: IndexPath
        if offset.y < height!*0.4 && offsetY.y - offset.y > 0{//往前一个月
            if currentSection > 0 {
                currentSection -= 1
            }
            goPreviousMonth()
        }else if offset.y > height!*1.6 && offsetY.y - offset.y < 0 {//往后一个月
            if currentSection < 2 {
                currentSection += 1
            }
            goNextMonth()
        }else{//保持当前月
            currentSection = 1
        }
        
        currentIndexPath = IndexPath.init(row: 0, section: currentSection)
        
        calendarCollectionView?.scrollToItem(at: currentIndexPath, at: UICollectionViewScrollPosition.top, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let indexPath = IndexPath.init(row: 0, section: 1)
        
        calendarCollectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
    }
    
    func getDates() {
        currentDate = Date()
        currentDatesArr = DateManager.dateManager.getDateModels(aDate: currentDate!)
        previousDate = Date().getLastDate(date: Date())
        previousDatesArr = DateManager.dateManager.getDateModels(aDate: previousDate!)
        nextDate = Date().getNextDate(date: Date())
        nextDateDatesArr = DateManager.dateManager.getDateModels(aDate: nextDate!)        
    }
    
}

