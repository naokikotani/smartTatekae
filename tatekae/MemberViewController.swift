//
//  MemberViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/24.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift

class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MemberTableViewCellDelegate {
    
    @IBOutlet var memberTableView: UITableView!
    var navigationText: String!
    var memberArray: [String] = []
    var sumArray: [Int] = []
    var information = [InformationModel]()
    //選ばれた番号
    var selectedNumber: Int = 0
    var selectedNumber2: Int = 0
    var date: String!
//    遷移元から渡された値
    var passedEventName: String!
    var passedEventDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        バックボタンを非表示にする
        self.navigationItem.hidesBackButton = true
        memberTableView.delegate = self
        memberTableView.dataSource = self
        // カスタムセルの登録
        let nib = UINib(nibName: "MemberTableViewCell", bundle: Bundle.main)
        memberTableView.register(nib, forCellReuseIdentifier: "memberTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = navigationText
        loadData()
        memberTableView.reloadData()
//        空のセルのセパレーターを消す
        memberTableView.tableFooterView = UIView(frame: .zero)
    }
    
//      セルの取得
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "memberTableViewCell") as! MemberTableViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        // セルに表示する値を設定する
        cell.memberNameLabel!.text = memberArray[indexPath.row]
        cell.paymentLabel!.text = String(sumArray[indexPath.row]) + "円"
        return cell
    }
    
//    セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    
//    セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNumber = indexPath.row
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toPaymentController", sender: self)
    }
    
    func loadData()  {
    //  読み込み
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let passedInfo = passedEventName!
        let passedInfo2 = passedEventDate!
        let allInfo = realm.objects(InformationModel.self).filter("eventName == %@ && payDate == %@", passedInfo, passedInfo2)
    //  Xcode内の）倉庫を初期化
        information = [InformationModel]()
    //  倉庫のものを一つづつ取り出してxcode内の倉庫に追加
        for i in allInfo {
            information.append(i)
        }
        
//      配列にメンバーと合計立替金を追加
        memberArray = []
        sumArray = []
        for i in 0 ..< information[0].member.count {
            memberArray.append(information[0].member[i].member!)
            sumArray.append(information[0].member[i].cost.sum(ofProperty: "cost"))
        }
    }
    
    //    支払い追加ボタンを押した時のアクション
    func tapAddPaymentButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedNumber2 = tableViewCell.tag
        performSegue(withIdentifier: "toAddPaymentController", sender: nil)
    }
    
    //    値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPaymentController" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? PaymentViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.passedEventDate = self.passedEventDate
            next?.passedEventName2 = self.navigationText
            next?.passedNumber = self.selectedNumber
            next?.passedSum = self.sumArray[selectedNumber]
            
        } else if segue.identifier == "toAddPaymentController" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? AddPaymentViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.passedNumber2 = self.selectedNumber2
            next?.passedEventName = self.navigationText
            next?.passedDate = self.passedEventDate
        } else if segue.identifier == "toResultViewController" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? ResultViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.passedEventName3 = self.navigationText
            next?.passedDate3 = self.passedEventDate
        }
    }
    
//    精算ボタンを押した時のアクション
    @IBAction func settleButton() {
        performSegue(withIdentifier: "toResultViewController", sender: nil)
    }
    
}


