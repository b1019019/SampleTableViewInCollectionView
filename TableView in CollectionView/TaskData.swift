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

let calendar = Calendar(identifier: .gregorian)

var today = calendar.date(from: DateComponents(year: 2021, month: 8, day: 21))!

var branch = TaskData(title: "延長", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 25, completeYear: 2021, completeMonth: 8, completeDay: 30, status: 0, nextTask: nil, branchTask:nil, extendHistory: nil)

var branchTask = [branch]

var nextTask = TaskData(title: "継続タスク子供", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 24, completeYear: 2021, completeMonth: 8, completeDay: 29, status: 2, nextTask: nil, branchTask: nil, extendHistory: nil)

var taskDataArray: [[TaskData]] = [
    [
        TaskData(title: "21日からの予定", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 21, completeYear: 2021, completeMonth: 8, completeDay: 23, status: 1, nextTask: nil, branchTask: nil, extendHistory: nil),
        TaskData(title: "21日からの予定２", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 21, completeYear: 2021, completeMonth: 8, completeDay: 24, status: 2, nextTask: nil, branchTask: nil, extendHistory: nil),
        //延長つき
        TaskData(title: "22日からの予定", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 22, completeYear: 2021, completeMonth: 8, completeDay: 25, status: 0, nextTask: nil, branchTask: [], extendHistory: [calendar.date(from: DateComponents(year: 2021, month: 8, day: 23))!, calendar.date(from: DateComponents(year: 2021, month: 8, day: 25))!]),
    ],
    [
        //分岐タスク付き
        TaskData(title: "21日からの予定", memo: "分岐タスクメモ", startYear: 2021, startMonth: 8, startDay: 21, completeYear: 2021, completeMonth: 8, completeDay: 23, status: 1, nextTask: nil, branchTask: branchTask, extendHistory: nil),
        branch,
        TaskData(title: "継続タスク親", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 21, completeYear: 2021, completeMonth: 8, completeDay: 22, status: 2, nextTask: nextTask, branchTask: nil, extendHistory: nil),
        TaskData(title: "21日からの予定", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 21, completeYear: 2021, completeMonth: 8, completeDay: 23, status: 1, nextTask: nil, branchTask: nil, extendHistory: nil),
        TaskData(title: "21日からの予定", memo: "えびです", startYear: 2021, startMonth: 8, startDay: 21, completeYear: 2021, completeMonth: 8, completeDay: 23, status: 1, nextTask: nil, branchTask: nil, extendHistory: nil)
    ]
]
