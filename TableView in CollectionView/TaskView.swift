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

}
