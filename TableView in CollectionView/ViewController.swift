//
//  ViewController.swift
//  TableView in CollectionView
//
//  Created by 山田純平 on 2021/08/13.
//

import UIKit

let calendar = Calendar(identifier: .gregorian)

var today = calendar.date(from: DateComponents(year: 2021, month: 8, day: 21))!

var data = [
    [
        ["0つ目","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"]
    ],
    [
        ["1つ目","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"]
    ],
    [
        ["2つ目","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"]
    ],
    [
        ["3つ目","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"]
    ],
    [
        ["4つ目","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"],
        ["1","1","1","1"]
    ]
]

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

var positionInData = 2

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        branch.parentTask = taskDataArray[1][0]
        
        //セル同士の間隔を設定
        collectionViewFlowLayout.minimumLineSpacing = 0
        //ページングスクロール
        collectionView.isPagingEnabled = true
        
        
        //nibNameはxibファイル名が入る
        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        //登録
        collectionView.register(nib, forCellWithReuseIdentifier: "collectionViewCell")
        
        /*
         NotificationCenter.default.addObserver(self, selector: #selector(receiveScrollNotification(notification:)), name: .tableScroll, object: nil)
         */
    }
    
    //collectionViewなどの描画が終わってから処理される
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //描画が完了してから呼び出さないと正常に動作しない
        //row:2 は中心の列のindex
        //スクロール初期位置を真ん中に設定
        collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        
    }
    //左に向かってスクロール(右にデータが増える)
    func leftScrollDataReload() {
        positionInData += 1
        let addData = [
            ["\(positionInData+2)つ目","1","1","1"],
            ["right","1","1","1"],
            ["1","1","1","1"],
            ["1","1","1","1"]
        ]
        data.removeFirst()
        data.append(addData)
        //表示日を+4日
        today = calendar.date(byAdding: .day, value: 4, to: today)!
    }
    
    //右に向かってスクロール(左にデータが増える)
    func rightScrollDataReload() {
        positionInData -= 1
        let addData = [
            ["\(positionInData-2)つ目","1","1","1"],
            ["left","1","1","1"],
            ["1","1","1","1"],
            ["1","1","1","1"]
        ]
        data.removeLast()
        data.insert(addData, at: 0)
        //表示日を-4日
        today = calendar.date(byAdding: .day, value: -4, to: today)!
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return taskDataArray.count
    }
    /*
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "FF"
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data[0].count
        return taskDataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //register()引数のreusedIdentifier(テーブルビュー)ごとにreusequeが存在する。ここで各テーブルビューの情報は保存されるため、前のセルの情報が残る。
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CustomTableViewCell
        
        //cell.label1.text = data[tableView.tag][0][indexPath.row]
        //cell.label2.text = data[tableView.tag][1][indexPath.row]
        //cell.label3.text = data[tableView.tag][2][indexPath.row]
        //cell.label4.text = data[tableView.tag][3][indexPath.row]
        
        //以前のaddViewを削除。以前のセルを再利用しているから削除できる？
        
        /*if tableView.tag == 2 {
            print(cell.subviews.count)
        }*/
        
        cell.removeAllSubviews()
        //再生されたcellで前のPathが残っているから同じものが描画され続ける
        cell.path = UIBezierPath()
        cell.removeAllShapeLayers()
        
        cell.leftEndDate = calendar.date(byAdding: .day, value: (tableView.tag - 2) * 4, to: today)!
        _ = cell.addTaskCell(taskData: taskDataArray[indexPath.section][indexPath.row])
        
        
        
        //TVCで追加したTaskViewとShapeLayerを削除するために、参照を保存する必要がある。配列を作って、そこに保存し、参照ごと削除する作戦
        
        //cell.test(row: indexPath.row)
        cell.label1.text = "表示"
        /*
         if !(tableView.tag == 1 && indexPath.row == 1){
         cell.textLabel?.text = data[tableView.tag][indexPath.row]
         
         }
         */
        return cell
    }
    
    
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
        //DatasourceとDelegateに自クラスを設定
        print("リロード前の高さ",cell.tableView.contentOffset.y)
        cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        print("リロード後の高さ",cell.tableView.contentOffset.y)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //コレクションビューと同サイズに設定
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //let currentOffsetX = scrollView.contentOffset.x//スクロールできる限度の底を基準にどのくらいスクロールしているか
        //let maximumOffset = scrollView.contentSize.width / 2 - scrollView.frame.width / 2//スクロールできる限度。スクロールする中身のビューの幅 - テーブルびゅー自体の幅
        //let distanceToBottom = maximumOffset - currentOffsetX
        
        //contentの右側に40の余白ができる
        let contentCenter = (scrollView.contentSize.width - 40) / 2
        
        let currentCenter = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        
        let positionFromCenter = contentCenter - currentCenter
        
        //print("\(contentCenter),\(currentCenter),\(positionFromCenter)")
        //print("ddddd\(scrollView.contentOffset.x),\(scrollView.frame.width),\(scrollView.contentSize.width)")
        //次のコレクションセルのテーブルビューの中心に移動したら
        //右にスライド(左の画面に移動)
        //print("\(data[0][0][0]),\(data[1][0][0]),\(data[2][0][0]),\(data[3][0][0]),\(data[4][0][0])")
        //スクロール時にNotificationCenterに通知を送る。scrollViewも送る。
        NotificationCenter.default.post(name: .scrollTableView, object: scrollView)
        
        
        //右にスライド(左画面に移動)
        if scrollView.frame.width - 5 < positionFromCenter {
            
            rightScrollDataReload()
            collectionView.reloadData()
            print("reloadLeft")
            
            //中央に戻る
            collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            
            //左にスライド(右の画面に移動)
        } else if positionFromCenter < -scrollView.frame.width + 5 {
            
            leftScrollDataReload()
            collectionView.reloadData()
            print("reloadRight")
            
            //中央に戻る
            collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            
        }
        
        
    }
}
