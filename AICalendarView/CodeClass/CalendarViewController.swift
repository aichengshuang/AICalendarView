//
//  CalendarViewController.swift
//  AICalendarView
//
//  Created by ai on 2017/6/2.
//  Copyright © 2017年 oraro. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController,CalendarViewDelegate {
    
    @IBOutlet weak var yearLab: UILabel!
    
    @IBOutlet weak var monthLab: UILabel!
    
    @IBOutlet weak var calendarView: CalendarView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Calendar"
        
        let arr = formatterCurrentDate(date: Date())
        
        setYearAndMonth(array: arr)
        
//        view.layoutIfNeeded()
        calendarView.delegate = self
        
        calendarView.setUpViews(isScrollEnable: false)
        
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        calendarView.goPreviousMonth()
        setYearAndMonth(array: formatterCurrentDate(date: calendarView.currentDate!))
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        calendarView.goNextMonth()
        setYearAndMonth(array: formatterCurrentDate(date: calendarView.currentDate!))
    }
    
    func setYearAndMonth(array: [String]) {
        monthLab.text = array[1]
        yearLab.text = array[0]
//        title = array[0] + "-" + array[1] + "-" + array[2]
    }
    
//    MARK: - formatterCurrentDate
    func formatterCurrentDate(date: Date) -> [String] {
        var arr: [String] = Array.init()
        let year = DateFormatter()
        year.dateFormat = "yyyy"
        arr.append(year.string(from: date))
        let month = DateFormatter()
        month.dateFormat = "MMMM"
        arr.append(month.string(from: date))
        let day = DateFormatter()
        day.dateFormat = "dd"
        arr.append(day.string(from: date))
        return arr
    }
    
    func getCurrentDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date)
        print("That day is \(str)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
