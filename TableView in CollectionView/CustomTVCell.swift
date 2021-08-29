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
    
    var path = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addTaskCell(taskData: TaskData) {
        //shapeLayerの大きさ設定。awakeFromNib時に行うと、heightForRowAtのTVセルの大きさ設定が適用されていない。なのでshapeLayer.frameの大きさ設定がおかしくなる
        shapeLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
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
                
                //分岐タスクの子タスクが表示4日より未来の場合、ここでreturnされて横線を引けなくなる
                
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
            indexDate = calendar.date(byAdding: .day, value: 1, to: indexDate)!
        }
        
        ////ここまででやっていること：TaskViewの大きさ設定、startの設定、丸角の設定
        
        let addViewPath = UIBezierPath()//ベジエパスクラス
        //UIViewを作り、挿入,親ビュー(CustomTVCell)のx,y座標を0としてRectを決める
        let addView = TaskView(frame: CGRect(x: CGFloat(start) * (self.frame.width/4), y: CGFloat(0), width: taskWidth, height: self.frame.height),task: taskData,path: addViewPath)
        
        /*
         path.move(to: CGPoint(x: CGFloat(1) * self.frame.width/4 - addView.frame.origin.x, y: addView.frame.midY))
         path.addLine(to: CGPoint(x: CGFloat(2) * self.frame.width/4 - addView.frame.origin.x, y: addView.frame.midY))
         */
        
        
        
        let originX = addView.frame.origin.x
        print("originX",originX)
        //2つ目のインデックス
        var indexDate2 = leftEndDate!
        indexDate2 = calendar.date(byAdding: .day, value: start, to: indexDate2)!
        var lastExtendGoal = start
        
        //延長履歴を表示
        if let exDates = taskData.extendHistory {
            for i in start...3 {
                if exDates.contains(indexDate2) {
                    //startからこのDateの右端まで横線
                    //スタートの代わりの変数を用意して前の縦線を引いたDateを保存する。次延長日時が見つかった時、この縦線の隣から横線を引く
                    addView.extendDraw(exStart: CGFloat(lastExtendGoal) * self.frame.width/4 - originX, exGoal: CGFloat(i + 1) * self.frame.width/4 - originX)
                    lastExtendGoal = i + 1
                }
                indexDate2 = calendar.date(byAdding: .day, value: 1, to: indexDate2)!
            }
            //表示している4日よりも大きい日が出た時
            if exDates.contains(where: {(element) -> Bool in return rightEndDate < element } ) {
                //タスク終わりまで横線を引く
                addView.horizontalDraw(exStart: CGFloat(lastExtendGoal) * self.frame.width/4 - originX, exGoal: addView.frame.maxX)
                
            }
        }
        
        //分岐タスクを表示
        //自分が分岐の親だった場合
        if let branch = taskData.branchTask {
            addView.downConnect()
        }
        //自分が分岐の子だった場合
        print(taskData.parentTask)
        if let parent = taskData.parentTask {
            print("child")
            //親タスクの開始日が表示されている4日間より過去である場合
            if parent.startDate < leftEndDate! {
                //子タスクの開始日が左端日だった場合
                if  leftEndDate! <= taskData.startDate && taskData.startDate <= rightEndDate {
                    //TVC自身にタスク開始日まで横点線を引く
                    let gap = calendar.dateComponents([.day], from: leftEndDate!, to: taskData.startDate).day!
                    
                    horizontalDraw(startX: shapeLayer.bounds.minX, goalX: CGFloat(gap) * self.bounds.width/4)
                    
                    //addViewに丸と横点線を引く
                    addView.horizontalConnect()
                    
                } else if rightEndDate < taskData.startDate {
                    //TVC全てに点線を引く
                    horizontalDraw(startX: bounds.minX, goalX: bounds.maxX)
                }
                //親タスクの開始日が表示されている4日間のどれかである場合
            } else if leftEndDate! <= parent.startDate && parent.startDate <= rightEndDate {
                print("親タスクが4日以内")
                if parent.startDate == taskData.startDate {
                    //addViewに縦線と丸を書く
                    addView.upConnect()
                } else if parent.startDate < taskData.startDate && taskData.startDate <= rightEndDate {
                    print("今回")
                    let gapParent = calendar.dateComponents([.day], from: leftEndDate!, to: parent.startDate).day!
                    let gap = calendar.dateComponents([.day], from: leftEndDate!, to: taskData.startDate).day!
                    print(gapParent,gap)
                    
                    //TVCに直接描画
                    horizontalDrawFromTop(startX: 10 + CGFloat(gapParent) * self.bounds.width/4, goalX: CGFloat(gap) * self.bounds.width/4)
                    
                    //addViewに丸と横点線を引く
                    addView.horizontalConnect()
                } else if parent.startDate < taskData.startDate && rightEndDate < taskData.startDate {
                    print("fafa")
                    horizontalDraw(startX: bounds.minX, goalX: bounds.maxX)
                }
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
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 5.0
        //色塗らんと見えない
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        
        self.addSubview(addView)
        
        self.layer.addSublayer(shapeLayer)
        
        /*
         path.move(to: CGPoint(x: 0, y: shapeLayer.frame.midY))
         path.addLine(to: CGPoint(x: shapeLayer.frame.maxX, y: shapeLayer.frame.midY))
         shapeLayer.lineWidth = 10.0
         shapeLayer.strokeColor = UIColor.cyan.cgColor
         shapeLayer.path = path.cgPath
         //shapeLayer.backgroundColor = UIColor.black.cgColor
         layer.addSublayer(shapeLayer)
         */
        
    }
    
    private func horizontalDraw(startX: CGFloat,goalX: CGFloat) {
        path.move(to: CGPoint(x: startX, y: bounds.midY))
        path.addLine(to: CGPoint(x: goalX, y: bounds.midY))
    }
    
    private func horizontalDrawFromTop(startX: CGFloat,goalX: CGFloat) {
        path.move(to: CGPoint(x: startX, y: bounds.minY))
        path.addLine(to: CGPoint(x: startX, y: bounds.midY))
        horizontalDraw(startX: startX, goalX: goalX)
    }
    
    
    func test (row: Int) {
        
        let sl = CAShapeLayer()
        //フレームの大きさが原因？、バグ発生から解決までの道のりを書き残す
        //frame.origin.xと0の違い！！
        sl.frame = CGRect(x: 0, y: 0, width: frame.width * CGFloat(row+1)/4, height: frame.height)
        sl.backgroundColor = UIColor.black.cgColor
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 0, y: sl.frame.midY))
        p.addLine(to: CGPoint(x: sl.frame.maxX, y: sl.frame.midY))
        sl.path = p.cgPath
        sl.lineWidth = 5.0
        sl.strokeColor = UIColor.cyan.cgColor
        layer.addSublayer(sl)
    }
    
    override func draw(_ rect: CGRect) {
        //path.stroke()
        
        
    }
    
}
