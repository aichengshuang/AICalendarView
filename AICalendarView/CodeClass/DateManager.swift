//
//  DateManager.swift
//  PanoramicAgriculture
//
//  Created by ai on 2017/5/26.
//  Copyright © 2017年 oraro. All rights reserved.
//

import UIKit

//用于时间管理
class DateManager: NSObject {
    
    //单例
    static let dateManager = DateManager()
    
    //初始时调用该方法，返回数组[DateModel]
    func getDateModels(aDate:Date) -> [DateModel] {
        
        var dateModelsArr: [DateModel] = Array.init()

        let calendar = Calendar.current
        let year = calendar.component(Calendar.Component.year, from: aDate)
        let month = calendar.component(Calendar.Component.month, from: aDate)
//        let day = calendar.component(Calendar.Component.day, from: aDate)
        
        let currentDateComponent = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: Date())
        
        var lastMonth = month - 1
        var nextMonth = month + 1
        var lastYear = year
        var nextYear = year

        if month == 1 {
            lastMonth = 12
            lastYear -= 1
        }else if month == 12{
            nextMonth = 1
            nextYear += 1
        }
        
        //1、算出这三个月各有多少天
        let dayCount = aDate.getMonthHowManyDay(date: aDate)
        
        var lastDayCount = aDate.getLastDateLenght(date: aDate)

//        var nextDayCount = aDate.getNextDateLenght(date: aDate)

        //2、算出这个月的1号是周几
        let firstWeekDay = aDate.getMontFirstWeekDay()

        //3、给出这个月的日期数据
        lastDayCount = lastDayCount - firstWeekDay
        
        if firstWeekDay != 0 {
            for i in 1...firstWeekDay {
                let dateModel = DateModel.init()
                dateModel.year = lastYear
                dateModel.month = lastMonth
                dateModel.day = lastDayCount + i
                dateModel.isPrevMonth = true
                dateModelsArr.append(dateModel)
            }
        }

        for i in firstWeekDay...firstWeekDay+dayCount-1 {
            let dateModel = DateModel.init()
            dateModel.year = year
            dateModel.month = month
            dateModel.day = i - firstWeekDay + 1
//            dateModel.isSelected = day == i ? true : false
            dateModel.isToday = (currentDateComponent.year == dateModel.year && currentDateComponent.month == dateModel.month && currentDateComponent.day == dateModel.day) ? true : false//确保是今天
            dateModelsArr.append(dateModel)
        }
        
        for i in firstWeekDay+dayCount...41 {
            let dateModel = DateModel.init()
            dateModel.year = nextYear
            dateModel.month = nextMonth
            dateModel.day = i - firstWeekDay - dayCount + 1
//            dateModel.isSelected = day == i ? true : false
            dateModel.isNextMonth = true
            dateModelsArr.append(dateModel)
        }
        
        return dateModelsArr
        
    }
    
    func getFirstWeekDayIndex(firstWeekDay: Int) -> Int {
        if firstWeekDay == 6 {
            return 1
        }else{
            return firstWeekDay + 1
        }
    }
    

}

//时间数据的模型
class DateModel: NSObject{
    
    var date: Date?                     //具体日期
    var year: Int?                      //年
    var month: Int?                     //月
    var day: Int?                       //日
//    var isSelected: Bool = false        //是否被选中
    var tag: NSInteger?                 //tag值
    var isPrevMonth: Bool = false       //是否是上个月
    var isNextMonth: Bool = false       //是否是下个月
    var isToday: Bool = false           //是否是今天
    
    
    
    
}

//对Date的扩展

extension Date {
    
    /**
     
     获取某个月有多少天
     
     */
    
    func getMonthHowManyDay(date:Date) ->Int {
        
        //我们大致可以理解为：某个时间点所在的“小单元”，在“大单元”中的数量
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)
        return (range?.upperBound)! - 1
        
    }
    
    
    
    // 获取日期是星期几
    
    func getDateWeekDay() ->Int {
        
        let dateFmt = DateFormatter()
        
        dateFmt.dateFormat  = "yyyy-MM-dd HH:mm:ss"
        
        let interval = Int(self.timeIntervalSince1970)
        
        let days = Int(interval/86400)
        
        let weekday = ((days + 4) % 7 + 7 ) % 7
        
        return weekday
        
    }
    
    
    
    /**
     
     *  获取这个月第一天是星期几
     
     */
    
    func getMontFirstWeekDay() ->Int {
        
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        
        let calendar = Calendar.current
        
        //这里注意 Swift要用这样方式写
        
        var com = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from:self)
        
        //设置成第一天
        com.day = 1
        
        let date = calendar.date(from: com)
        
        //我们大致可以理解为：某个时间点所在的“小单元”，在“大单元”中的位置  ordinalityOfUnit
        
        let firstWeekDay = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: date!)
        
        return firstWeekDay! - 1
        
    }
    
    
    /**
     
     获取指定时间下一个月的时间
     
     */
    
    func getNextDate(date:Date) -> Date {
        
        let calendar = NSCalendar.current
        
        var com = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from:date)
        
        //取到当前时间
        let component = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from:Date())
        
        com.month! += 1
        
        com.day = 1
        
        if com.month == com.month! - 1 {
            
            com.day = com.day
            
        }
        //如果和当前时间相同，则取到今天
        if com.year == component.year && com.month == component.month {
            com.day = component.day
        }
        
        
        return calendar.date(from: com)!
        
    }
    
    
    
    /**
     
     获取指定时间上一个月的时间
     
     */
    
    func getLastDate(date:Date) -> Date {
        
        let calendar = Calendar.current
        
        var com = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from:date)
        
        //取到当前时间
        let component = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from:Date())
        
        com.month! -= 1
        
        com.day = 1
        
        if com.month == com.month! + 1 {
            
            com.day = com.day
            
        }
        
        //如果和当前时间相同，则取到今天
        if com.year == component.year && com.month == component.month {
            com.day = component.day
        }
        
        return calendar.date(from: com)!
        
    }
    
    
    
    /**
     
     获取指定时间下一个月的长度
     
     */
    
    func getNextDateLenght(date:Date) ->Int {
        
        let date = self.getNextDate(date:date)
        
        return date.getMonthHowManyDay(date:date)
        
    }
    
    
    
    /**
     
     获取指定时间上一个月的长度
     
     */
    
    func getLastDateLenght(date:Date) ->Int {
        
        let date = self.getLastDate(date:date)
        
        return date.getMonthHowManyDay(date: date)
        
    }
  
}
