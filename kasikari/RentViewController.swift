//
//  RentViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/29.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift

class RentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var rentTableView: UITableView!
    @IBOutlet var rentSegmentedControl : UISegmentedControl!
    var lendArray: [RentInformationModel] = []
    var rentArray: [RentInformationModel] = []
    var displayArray: [RentInformationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        rentTableView.delegate = self
        rentTableView.dataSource = self
        //        カスタムセルの登録
        let nib = UINib(nibName: "RentTableViewCell", bundle: Bundle.main)
        rentTableView.register(nib, forCellReuseIdentifier: "rentTableViewCell")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        segmentCheck()
        rentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = rentTableView.dequeueReusableCell(withIdentifier: "rentTableViewCell") as! RentTableViewCell
            cell.nameLabel.text = displayArray[indexPath.row].person
            cell.cashLabel.text = String(displayArray[indexPath.row].cash) + "円"
            cell.deadLineLabel2.text = displayArray[indexPath.row].deadLine
            cell.memoLabel.text = displayArray[indexPath.row].memo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func actionSegmentedControl(_ sender: UISegmentedControl) {
        rentTableView.reloadData()
    }
    
    func loadData()  {
    //  読み込み
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let allInfo = realm.objects(RentInformationModel.self)
    //  Xcode内の）倉庫を初期化
        var information = [RentInformationModel]()
        information = [RentInformationModel]()
    //  倉庫のものを一つづつ取り出してxcode内の倉庫に追加
        for i in allInfo {
            information.append(i)
        }
        
        lendArray = []
        rentArray = []
        for r in information {
            if r.select == "借りている" {
                lendArray.append(r)
            } else if r.select == "貸している" {
                rentArray.append(r)
            }
        }
    }
    
//    データの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//      realmの中から削除
        let realm = try! Realm()
        let person = displayArray[indexPath.row].person
        let cash = displayArray[indexPath.row].cash
        let deadline = displayArray[indexPath.row].deadLine
        let select = displayArray[indexPath.row].select
        let memo = displayArray[indexPath.row].memo
        let results = realm.objects(RentInformationModel.self).filter("person == %@ && cash == %@ && deadLine == %@ && select == %@ && memo == %@", person, cash, deadline, select, memo)
        try! realm.write {
                realm.delete(results)
        }
            
    //      配列から削除
            self.displayArray.remove(at: indexPath.row)
            rentTableView.reloadData()
        }
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        segmentCheck()
    }
    
    func segmentCheck() {
        loadData()
        if rentSegmentedControl.selectedSegmentIndex == 0 {
             displayArray = lendArray
             rentTableView.reloadData()
        } else if rentSegmentedControl.selectedSegmentIndex == 1{
            displayArray = rentArray
            rentTableView.reloadData()
        }
    }
}


