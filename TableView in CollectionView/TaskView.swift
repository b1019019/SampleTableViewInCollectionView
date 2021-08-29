//
//  TaskView.swift
//  TableView in CollectionView
//
//  Created by 山田純平 on 2021/08/23.
//

import UIKit

class TaskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var task: TaskData
    var path: UIBezierPath?
    
    init(frame: CGRect,task: TaskData,path: UIBezierPath) {
        self.task = task
        self.path = path
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func horizontalConnect() {
        path?.addArc(withCenter: CGPoint(x: bounds.minX + 10, y: bounds.midY), radius: 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path?.move(to: CGPoint(x: bounds.minX + 10, y: bounds.midY))
        path?.addLine(to: CGPoint(x: bounds.minX, y: bounds.midY))
    }
    
    func upConnect() {
        path?.addArc(withCenter: CGPoint(x: bounds.minX + 10, y: bounds.midY), radius: 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path?.move(to: CGPoint(x: bounds.minX + 10, y: bounds.midY))
        path?.addLine(to: CGPoint(x: bounds.minX + 10, y: bounds.minY))
    }
    
    func downConnect() {
        path?.addArc(withCenter: CGPoint(x: bounds.minX + 10, y: bounds.midY), radius: 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path?.move(to: CGPoint(x: bounds.minX + 10, y: bounds.midY))
        path?.addLine(to: CGPoint(x: bounds.minX + 10, y: bounds.maxY))
    }
    
    func extendDraw(exStart: CGFloat,exGoal: CGFloat) {
        path?.move(to: CGPoint(x: exStart, y: bounds.midY))
        path?.addLine(to: CGPoint(x: exGoal, y: bounds.midY))
        //縦線を引く
        path?.move(to: CGPoint(x: exGoal, y: bounds.minY))
        path?.addLine(to: CGPoint(x: exGoal, y: bounds.maxY))
    }
    
    func horizontalDraw(exStart: CGFloat,exGoal: CGFloat) {
        path?.move(to: CGPoint(x: exStart, y: bounds.midY))
        path?.addLine(to: CGPoint(x: exGoal, y: bounds.midY))
    }
    
    override func draw(_ rect: CGRect) {
        if let p = path {
            UIColor.gray.setStroke()
            p.lineWidth = 5.0
                //print("draw",path)
            p.stroke()
        }

        /*let pa = UIBezierPath()
        pa.move(to: CGPoint(x: rect.minX, y: rect.minY))
        pa.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        pa.lineWidth = 5.0
        pa.stroke()
        print(pa)*/
    }
    
    func cornerRadius(leftCornerRounded: Bool,rightCornerRounded: Bool) {
        //何の意味があるか調べておく
        self.clipsToBounds = true
        if !leftCornerRounded && rightCornerRounded {
            self.layer.cornerRadius = 15
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else if leftCornerRounded && !rightCornerRounded {
            self.layer.cornerRadius = 15
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if leftCornerRounded && rightCornerRounded {
            self.layer.cornerRadius = 15
        }
        
    }

}
