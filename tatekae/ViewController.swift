//
//  ViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/23.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var eventNameTableView: UITableView!
    var eventNameArray = [String]()
    var eventDateArray = [String]()
    var eventName: String!
    var eventDate: String!
    var events = [InformationModel]()
    var loginArray = [String]()
    var selectedCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTableView.dataSource = self
        eventNameTableView.delegate = self
        // カスタムセルの登録
        eventNameTableView.register(UINib(nibName: "ViewControllerTableViewCell", bundle: nil),forCellReuseIdentifier:"viewControllerTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        eventNameTableView.reloadData()

//        空のセルのセパレーターを消す
        eventNameTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewControllerTableViewCell", for: indexPath) as! ViewControllerTableViewCell
        // セルに表示する値を設定する
        cell.EventNameLabel!.text = eventNameArray[indexPath.row]
        cell.EventDateLabel!.text = eventDateArray[indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventNameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        performSegue(withIdentifier: "toMemberViewControllerSegue", sender: nil)
    }
    
//    データの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//      realmの中から削除
        let realm = try! Realm()
        let eventName = eventNameArray[indexPath.row]
        let eventDate = eventDateArray[indexPath.row]
        let results = realm.objects(InformationModel.self).filter("eventName == %@ && payDate == %@", eventName, eventDate)
        try! realm.write {
            realm.delete(results)
        }
        
//      配列から削除
        self.eventNameArray.remove(at: indexPath.row)
        self.eventDateArray.remove(at: indexPath.row)
        eventNameTableView.reloadData()
    }
    
    func loadData()  {
        //  読み込み
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let allInfo = realm.objects(InformationModel.self)
        //  Xcode内の）倉庫を初期化
        events = [InformationModel]()
        //  倉庫のものを一つづつ取り出してxcode内の倉庫に追加
        for i in allInfo {
            events.append(i)
        }
        
        eventNameArray = []
        eventDateArray = []
        for r in 0 ..<  events.count {
            eventNameArray.append(events[r].eventName)
            eventDateArray.append(events[r].payDate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemberViewControllerSegue" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? MemberViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.passedEventName = self.eventNameArray[selectedCell]
            next?.passedEventDate = self.eventDateArray[selectedCell]
            next?.navigationText = self.eventNameArray[selectedCell]
        }
    }
}
