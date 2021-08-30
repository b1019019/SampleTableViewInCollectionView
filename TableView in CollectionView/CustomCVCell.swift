//
//  CustomCVCell.swift
//  TableView in CollectionView
//
//  Created by 山田純平 on 2021/08/13.
//

import UIKit

extension Notification.Name {
    static let scrollTableView = Notification.Name("scrollTableView")
}

class CustomCVCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nib = UINib(nibName: "CustomTVCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tableViewCell")
        
        //スクロール時に送られた通知を受け取り、receiveScrollNotificationを実行
        NotificationCenter.default.addObserver(self, selector: #selector(receiveScrollNotification(notification:)), name: .scrollTableView, object: nil)
    }
    
    @objc func receiveScrollNotification(notification: NSNotification) {
        guard let scrollView = notification.object as? UIScrollView else {
            return
        }
        
        if !(scrollView.tag == tableView.tag) {
        tableView.contentOffset.y = scrollView.contentOffset.y
        }
        
    }
    
    
    
    //テーブルビューのDataSource(表示する内容)とDelegate(テーブルビューの表示、操作)の権限委譲
    func setTableViewDataSourceDelegate
    <D: UITableViewDataSource & UITableViewDelegate>
    (dataSourceDelegate: D, forRow row: Int) {
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        //tagにCollectionViewのrowを設定させ、それによりテーブルビューの内容を変える
        tableView.tag = row
        //tableViewのデリゲート、データソースの関数を実行させる
        tableView.reloadData()
    }
}
