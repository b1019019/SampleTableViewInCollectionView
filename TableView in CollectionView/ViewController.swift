//
//  ViewController.swift
//  TableView in CollectionView
//
//  Created by 山田純平 on 2021/08/13.
//

import UIKit

enum ViewControllerMaxDisplyedDays: Int {
    case minimum = 4
    case middle = 7
    case max = 10
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isPagingEnabled = true
            let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "collectionViewCell")
        }
    }
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewFlowLayout.minimumLineSpacing = 0
        }
    }
    
    private let maxDisplayedDays: ViewControllerMaxDisplyedDays = .minimum
    private let calendar = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        branch.parentTask = taskDataArray[1][0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToCenter(inSection: 0)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // register()引数のreusedIdentifier(テーブルビュー)ごとにreusequeが存在する。
        // ここで各テーブルビューの情報は保存されるため、前のセルの情報が残る。
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CustomTableViewCell
        cell.removeAllSubviews()
        //再生されたcellで前のPathが残っているから同じものが描画され続ける
        cell.path = UIBezierPath()
        cell.removeAllShapeLayers()
        cell.leftEndDate = calendar.date(byAdding: .day, value: (tableView.tag - 2) * 4, to: today)!
        cell.addTaskCell(taskData: taskDataArray[indexPath.section][indexPath.row])
        cell.label1.text = "表示"
        return cell
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension ViewController {
    enum Slide: Int {
        case toLeft = 1
        case toRight = -1
        case nothing = 0
        
        init (currentPage: Int, currentPosition: CGFloat, pageWidth: CGFloat) {
            let previous = currentPage - 1
            let next = currentPage + 1
            switch currentPosition {
            case pageWidth * CGFloat(previous):
                self = .toRight
            case pageWidth * CGFloat(next):
                self = .toLeft
            default:
                self = .nothing
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //スクロール時にNotificationCenterに通知を送る。scrollViewも送る。
        NotificationCenter.default.post(name: .scrollTableView, object: scrollView)
        let slide: Slide = Slide(currentPage:collectionView.centerIndex(inSection: 0), currentPosition: scrollView.contentOffset.x, pageWidth: scrollView.frame.width)
        guard slide != .nothing else { return }
        collectionView.scrollToCenter(inSection: 0)
        collectionView.reloadData()
        today = calendar.date(byAdding: .day, value: maxDisplayedDays.rawValue * slide.rawValue, to: today)!
    }
}
