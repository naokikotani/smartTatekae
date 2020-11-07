//
//  PaymentViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/10/01.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift



class PaymentViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var paymentTableView: UITableView!
    @IBOutlet var sumLabel: UILabel!
    @IBOutlet var sumLabel2: UILabel!
    var passedEventDate: String!
    var paymentArray: [String] = []
    var cashArray: [Int] = []
    var pay = [InformationModel]()
    var passedEventName2: String!
    var passedNumber: Int!
    var passedSum: Int!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        // カスタムセルの登録
        let nib = UINib(nibName: "PaymentViewControllerTableViewCell", bundle: Bundle.main)
        paymentTableView.register(nib, forCellReuseIdentifier: "paymentViewControllerTableVireCell")
        //        空のセルのセパレーターを消す
        paymentTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        paymentTableView.reloadData()
        loadData()
        let sum = cashArray.reduce(0) { $0 + $1 }
        sumLabel2.text = String(sum) + "円"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = paymentTableView.dequeueReusableCell(withIdentifier: "paymentViewControllerTableVireCell") as! PaymentViewControllerTableViewCell
        // セルに表示する値を設定する
        cell.costNameLabel!.text = paymentArray[indexPath.row]
        cell.costLabel!.text = String(cashArray[indexPath.row]) + "円"
        return cell
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadData()  {
    //  読み込み
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let passedInfo = passedEventName2!
        let passedInfo2 = passedEventDate!
        let allInfo = realm.objects(InformationModel.self).filter("eventName == %@ && payDate == %@", passedInfo, passedInfo2)
    //  Xcode内の）倉庫を初期化
        pay = [InformationModel]()
    //  倉庫のものを一つづつ取り出してxcode内の倉庫に追加
        for i in allInfo {
            pay.append(i)
        }
        
        for r in  0 ..< pay[0].member[passedNumber].cost.count {
            cashArray.append(pay[0].member[passedNumber].cost[r].cost)
            paymentArray.append(pay[0].member[passedNumber].costName[r].costName)
        }
    }
    
//    データの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
//      realmの中から削除
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let passedInfo = passedEventName2!
        let passedInfo2 = passedEventDate!
        let allInfo = realm.objects(InformationModel.self).filter("eventName == %@ && payDate == %@", passedInfo, passedInfo2)
        //  Xcode内の）倉庫を初期化
        pay = [InformationModel]()
        //  倉庫のものを一つづつ取り出してxcode内の倉庫に追加
        for i in allInfo {
            pay.append(i)
        }
        cashArray = []
        paymentArray = []
        for r in  0 ..< pay[0].member[passedNumber].cost.count {
            cashArray.append(pay[0].member[passedNumber].cost[r].cost)
            paymentArray.append(pay[0].member[passedNumber].costName[r].costName)
        }
            try! realm.write {
                realm.delete(pay[0].member[passedNumber].cost[indexPath.row])
                realm.delete(pay[0].member[passedNumber].costName[indexPath.row])
                }
                    
//      配列から削除
        self.cashArray.remove(at: indexPath.row)
        self.paymentArray.remove(at: indexPath.row)
        
//        更新
        paymentTableView.reloadData()
        let sum = cashArray.reduce(0) { $0 + $1 }
        sumLabel2.text = String(sum) + "円"
    }
}

