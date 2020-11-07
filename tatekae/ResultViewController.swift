//
//  ResultViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/24.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit

import RealmSwift
import Accounts
import LINEActivity

class ResultViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var resulTableView: UITableView!
    var information = [InformationModel]()
    var passedDate3: String!
    var passedEventName3: String!
    var sumArray: [Int] = []
    var memberArray: [String] = []
    var plusArray: [MemberModel] = []
    var minusArray: [MemberModel] = []
    var plusMemberArray: [String] = []
    var minusMemberArray: [String] = []
    var resultArray: [Int] = []
    var textArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resulTableView.delegate = self
        resulTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        check()
        same()
        result()
        sendText()
        // カスタムセルの登録
        let nib = UINib(nibName: "ResultViewControllerTableViewCell", bundle: Bundle.main)
        resulTableView.register(nib, forCellReuseIdentifier: "resultViewControllerTableViewaCell")
//        空のセルのセパレーターを消す
        resulTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = resulTableView.dequeueReusableCell(withIdentifier: "resultViewControllerTableViewaCell") as! ResultViewControllerTableViewCell
        cell.resultLabel!.text = minusMemberArray[indexPath.row] + "が" + plusMemberArray[indexPath.row] + "に" +  String(resultArray[indexPath.row]) + "円渡す"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func sendText() {
        textArray = []
        for i in 0 ..< resultArray.count {
            textArray.append(minusMemberArray[i] + "が" + plusMemberArray[i] + "に" +  String(resultArray[i]) + "円渡す")
        }
    }
    
//    LINE共有をした時のアクション
    @IBAction func sendLineButton(sender: UIButton) {
        var shareText = ""
        for text in textArray {
            shareText = shareText + text + " "
        }
        print(shareText)
        // 共有する項目
        let activityItems = [shareText] as [Any]
        let LineKit = LINEActivity()
        let myApplicationActivities = [LineKit]

        // 初期化してLineを追加
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: myApplicationActivities)

        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.print
        ]

        activityVC.excludedActivityTypes = excludedActivityTypes

        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
      }
    
//    支払いボタンを押した時のアクション
    @IBAction func payMoneyButton() {
    }
    

    func loadData()  {
    //  読み込み
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let passedDate4 = passedDate3!
        let passedEventName4 = passedEventName3!
        let allInfo = realm.objects(InformationModel.self).filter("eventName == %@ && payDate == %@", passedEventName4, passedDate4)
    // （Xcode内の）倉庫を初期化
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
        
//      総合計
        let result = sumArray.reduce(0) { $0 + $1 }
//      一人当たりが支払うべき金額
        let pay = result / memberArray.count
//        差額
        var differenceArray: [Int] = []
        for r in 0 ..< sumArray.count {
            let difference = sumArray[r] - pay
            differenceArray.append(difference)
            check()
        }
        
//        differenceを保存
        try! realm.write {
            for i in  0 ..<  differenceArray.count {
                information[0].member[i].difference = differenceArray[i]
            }
            realm.add(information)
        }
    }
    
//プラスとマイナスで分別
    func check() {
        plusArray = []
        minusArray = []
        for r in 0 ..< information[0].member.count {
        if information[0].member[r].difference > 0 {
            plusArray.append(information[0].member[r])
        } else if information[0].member[r].difference < 0 {
            minusArray.append(information[0].member[r])
            }
        }
    }
    
//    同じものを取り出して削除
    func same() {
        for r in plusArray {
            for i in minusArray {
                if r.difference + i.difference == 0 {
                    plusMemberArray.append(r.member)
                    minusMemberArray.append(i.member)
                    resultArray.append(r.difference)
                     if let  indexNum1 = plusArray.firstIndex(of: r) {
                                       plusArray.remove(at: indexNum1)
                                   }
                                   if let  indexNum2 = minusArray.firstIndex(of: i) {
                                       minusArray.remove(at: indexNum2)
                                   }
                }
            }
        }
    }
    
//    精算結果の算出
    func result() {
        guard plusArray.count > 0  else { return }
        for i in 0 ..< plusArray.count + minusArray.count - 1 {
            if plusArray[0].difference + minusArray[0].difference >= 0 {
                var pay: Int!
                pay = minusArray[0].difference * -1
                plusMemberArray.append(plusArray[0].member)
                minusMemberArray.append(minusArray[0].member)
                resultArray.append(pay)
                let realm = try! Realm()
                    try! realm.write {
                        plusArray[0].difference = plusArray[0].difference + minusArray[0].difference
                    }
                minusArray.removeFirst()
            } else if plusArray[0].difference + minusArray[0].difference < 0 {
                var pay2: Int!
                pay2 = plusArray[0].difference
                plusMemberArray.append(plusArray[0].member)
                minusMemberArray.append(minusArray[0].member)
                resultArray.append(pay2)
                let realm = try! Realm()
                    try! realm.write {
                        minusArray[0].difference = plusArray[0].difference + minusArray[0].difference
                    }
                plusArray.removeFirst()
            }
        }
    }
}
