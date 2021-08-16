//
//  ViewController.swift
//  TableView in CollectionView
//
//  Created by 山田純平 on 2021/08/13.
//

import UIKit

var data = [["yamada","20","gyoza","erogoPlaxy"],
            ["hajime","23","karubo","chihaya"],
            ["nozo","23","onigiri","eva"],
            ["ebi","20","kimuti","initialD"],
            ["wasabi","26","apple","eureka7"]]

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //セル同士の間隔を設定
        collectionViewFlowLayout.minimumLineSpacing = 0
        
        
        //nibNameはxibファイル名が入る
        let nib = UINib(nibName: "CustomCVCell", bundle: nil)
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
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CustomTVCell
        
        if !(tableView.tag == 1 && indexPath.row == 1){
            cell.textLabel?.text = data[tableView.tag][indexPath.row]
        }
        return cell
    }
    
    
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCVCell
        //DatasourceとDelegateに自クラスを設定
        cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        return size
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //スクロール時にNotificationCenterに通知を送る。scrollViewも送る。
        NotificationCenter.default.post(name: .scrollTableView, object: scrollView)
    }
}
