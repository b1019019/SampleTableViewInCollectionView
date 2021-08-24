//
//  CustomTVCell.swift
//  TableView in CollectionView
//
//  Created by 山田純平 on 2021/08/14.
//

import UIKit

class CustomTVCell: UITableViewCell {
    
    @IBOutlet weak var devideView1: UIView!
    @IBOutlet weak var devideView2: UIView!
    @IBOutlet weak var devideView3: UIView!
    @IBOutlet weak var devideView4: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    var leftEndDate: Date? = calendar.date(from: DateComponents(year: 2021, month: 8, day: 21))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addTaskCell(taskData: TaskData) {
        //左と右を丸角にするかどうか
        var leftCornerRounded = false
        var rightCornerRounded = false
        //生成するタスクの幅
        var taskWidth: CGFloat = 0
        //左端の日を基準とした日
        var dateFromLeftEnd = leftEndDate!
        //右端の日
        let rightEndDate = calendar.date(byAdding: .day, value: 3, to: dateFromLeftEnd)!
        //左端の日から数えたタスクが始まる日
        var start = 0
        //タスクの開始日がテーブルに表示される期間内にあるか
        if dateFromLeftEnd <= taskData.startDate && taskData.startDate <= rightEndDate {
            leftCornerRounded = true
            start = calendar.dateComponents([.day], from: dateFromLeftEnd, to: taskData.startDate).day!
            //dateFromLeftEndをスタートに合わせる
            dateFromLeftEnd = taskData.startDate
            //タスクの開始日がテーブルに表示される期間より遅いか
        } else if rightEndDate < taskData.startDate {
            return
        }
        
        //pathの座標設定はaddViewを基準にしているので
        var lastExtendGoal = 0//延長矢印のゴール
        
        //タスク終了まで幅の大きさを測る
        for i in start...3 {
            if dateFromLeftEnd < taskData.completeDate {
                taskWidth += self.frame.width/4
            } else if dateFromLeftEnd == taskData.completeDate {
                taskWidth += self.frame.width/4
                rightCornerRounded = true
                break
            }
            //ExtendHistoryと同じDateが出現した場合、StartからこのDateの右端まで横線を、このDateの右端に縦線を入れる
            
            
            dateFromLeftEnd = calendar.date(byAdding: .day, value: 1, to: dateFromLeftEnd)!
        }
        
        
        
        //path.close()
        
        
        
        //UIViewを作り、挿入
        //親ビュー(CustomTVCell)のx,y座標を0としてRectを決める
        let path = UIBezierPath()//ベジエパスクラス
        
        let addView = TaskView(frame: CGRect(x: CGFloat(start) * (self.frame.width/4), y: CGFloat(0), width: taskWidth, height: self.frame.height),task: taskData,path: path)
        
        /*
         path.move(to: CGPoint(x: CGFloat(1) * self.frame.width/4 - addView.frame.origin.x, y: addView.frame.midY))
         path.addLine(to: CGPoint(x: CGFloat(2) * self.frame.width/4 - addView.frame.origin.x, y: addView.frame.midY))
         */
        
        
        
        let originX = addView.frame.origin.x
        var dateFromLeftEnd2 = leftEndDate!
        dateFromLeftEnd2 = calendar.date(byAdding: .day, value: start, to: dateFromLeftEnd2)!
        
        var lastExtendGoal2 = start
        if let exDates = taskData.extendHistory {
            for i in start...3 {
                
                print(exDates,dateFromLeftEnd2)
                if exDates.contains(dateFromLeftEnd2) {
                    //startからこのDateの右端まで横線
                    //スタートの代わりの変数を用意して前の縦線を引いたDateを保存する。次延長日時が見つかった時、この縦線の隣から横線を引く
                    path.move(to: CGPoint(x: CGFloat(lastExtendGoal2) * self.frame.width/4 - originX, y: addView.frame.midY))
                    path.addLine(to: CGPoint(x: CGFloat(i + 1) * self.frame.width/4 - originX, y: addView.frame.midY))
                    print(lastExtendGoal2)
                    //縦線を引く
                     path.move(to: CGPoint(x: CGFloat(i + 1) * self.frame.width/4 - originX, y: addView.frame.minY))
                     path.addLine(to: CGPoint(x: CGFloat(i + 1) * self.frame.width/4 - originX, y: addView.frame.maxY))
                    lastExtendGoal2 = i + 1
                    
                }
                dateFromLeftEnd2 = calendar.date(byAdding: .day, value: 1, to: dateFromLeftEnd2)!
            }
        }
        
        if let exDates = taskData.extendHistory {
            if !exDates.contains(rightEndDate) {
                for d in exDates {
                    if rightEndDate < d {
                        //タスク終わりまで横線を引く
                        path.move(to: CGPoint(x: CGFloat(lastExtendGoal) * self.frame.width/4, y: addView.frame.minY))
                        path.addLine(to: CGPoint(x: self.frame.width, y: addView.frame.maxY))
                        break
                    }
                }
            }
        }
        
        
        if !leftCornerRounded && rightCornerRounded {
            addView.layer.cornerRadius = 15
            addView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else if leftCornerRounded && !rightCornerRounded {
            addView.layer.cornerRadius = 15
            addView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if leftCornerRounded && rightCornerRounded {
            addView.layer.cornerRadius = 15
        }
        
        addView.backgroundColor = UIColor.red
        addView.alpha = 0.6
        
        //self.frame.origin.xは値が動く
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: addView.frame.width, height: addView.frame.height))
        label.text = taskData.title
        label.textAlignment = NSTextAlignment.center
        addView.addSubview(label)
        
        self.addSubview(addView)
    }
    
}
