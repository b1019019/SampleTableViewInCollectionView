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
        //右端の日
        let rightEndDate = calendar.date(byAdding: .day, value: 3, to: leftEndDate!)!
        //生成するタスクの幅
        var taskWidth: CGFloat = 0
        //左と右を丸角にするかどうか
        var leftCornerRounded = false
        var rightCornerRounded = false
        
        
        //左端の日から数えたタスクが始まる日
        var start = 0
        //タスクの全体を辿るためのインデックス
        var indexDate = leftEndDate!
        //タスクの開始日がテーブルに表示される期間内にあるか
        if let l = leftEndDate {
            if l <= taskData.startDate && taskData.startDate <= rightEndDate {
                leftCornerRounded = true
                //タスクが始まる日に合わせる
                start = calendar.dateComponents([.day], from: l, to: taskData.startDate).day!
                //タスクが始まる日に合わせる
                indexDate = taskData.startDate
                //タスクの開始日がテーブルに表示される期間より遅いか
            } else if rightEndDate < taskData.startDate {
                return
            }
        }
        
        //タスク終了まで幅の大きさを測る
        for _ in start...3 {
            if indexDate < taskData.completeDate {
                taskWidth += self.frame.width/4
            } else if indexDate == taskData.completeDate {
                taskWidth += self.frame.width/4
                rightCornerRounded = true
                break
            }
            //ExtendHistoryと同じDateが出現した場合、StartからこのDateの右端まで横線を、このDateの右端に縦線を入れる
            indexDate = calendar.date(byAdding: .day, value: 1, to: indexDate)!
        }
        
        let path = UIBezierPath()//ベジエパスクラス
        //UIViewを作り、挿入,親ビュー(CustomTVCell)のx,y座標を0としてRectを決める
        let addView = TaskView(frame: CGRect(x: CGFloat(start) * (self.frame.width/4), y: CGFloat(0), width: taskWidth, height: self.frame.height),task: taskData,path: path)
        
        /*
         path.move(to: CGPoint(x: CGFloat(1) * self.frame.width/4 - addView.frame.origin.x, y: addView.frame.midY))
         path.addLine(to: CGPoint(x: CGFloat(2) * self.frame.width/4 - addView.frame.origin.x, y: addView.frame.midY))
         */
        
        
        
        let originX = addView.frame.origin.x
        //2つ目のインデックス
        var indexDate2 = leftEndDate!
        indexDate2 = calendar.date(byAdding: .day, value: start, to: indexDate2)!
        var lastExtendGoal = start
        
        if let exDates = taskData.extendHistory {
            for i in start...3 {
                if exDates.contains(indexDate2) {
                    //startからこのDateの右端まで横線
                    //スタートの代わりの変数を用意して前の縦線を引いたDateを保存する。次延長日時が見つかった時、この縦線の隣から横線を引く
                    path.move(to: CGPoint(x: CGFloat(lastExtendGoal) * self.frame.width/4 - originX, y: addView.frame.midY))
                    path.addLine(to: CGPoint(x: CGFloat(i + 1) * self.frame.width/4 - originX, y: addView.frame.midY))
                    //縦線を引く
                     path.move(to: CGPoint(x: CGFloat(i + 1) * self.frame.width/4 - originX, y: addView.frame.minY))
                     path.addLine(to: CGPoint(x: CGFloat(i + 1) * self.frame.width/4 - originX, y: addView.frame.maxY))
                    lastExtendGoal = i + 1
                }
                indexDate2 = calendar.date(byAdding: .day, value: 1, to: indexDate2)!
            }
            //表示している4日よりも大きい日が出た時
            if exDates.contains(where: {(element) -> Bool in return rightEndDate < element } ) {
                //タスク終わりまで横線を引く
                path.move(to: CGPoint(x: CGFloat(lastExtendGoal) * self.frame.width/4 - originX, y: addView.frame.midY))
                path.addLine(to: CGPoint(x: addView.frame.maxX, y: addView.frame.midY))
            }
        }
        
        //角丸化
        addView.cornerRadius(leftCornerRounded: leftCornerRounded, rightCornerRounded: rightCornerRounded)
        
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
