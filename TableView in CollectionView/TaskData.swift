//
//  TaskData.swift
//  TableView in CollectionView
//
//  Created by Hajime Ito on 2021/08/30.
//

import Foundation

class TaskData {
    var title: String
    var memo: String
    var startDate: Date
    var completeDate: Date
    var status: Int//0：取組み中 1：完了 2：諦め
    var nextTask: TaskData?
    var branchTask: [TaskData]?
    var parentTask: TaskData?
    var extendHistory: [Date]?//延長前の完了予定日を格納していく
    
    init(title: String,memo: String,startYear: Int, startMonth: Int,startDay: Int,completeYear: Int,completeMonth: Int , completeDay: Int,status: Int,nextTask: TaskData?,branchTask: [TaskData]?,extendHistory: [Date]?){
        self.title = title
        self.memo = memo
        self.startDate = calendar.date(from: DateComponents(year: startYear, month: startMonth, day: startDay))!
        self.completeDate = calendar.date(from: DateComponents(year: completeYear, month: completeMonth, day: completeDay))!
        self.status = status
        self.nextTask = nextTask
        self.branchTask = branchTask
        self.extendHistory = extendHistory
    }
}
