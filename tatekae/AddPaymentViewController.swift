//
//  PaymentViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/26.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD

class AddPaymentViewController: UIViewController {
    
    @IBOutlet var paymentLabl: UILabel!
    @IBOutlet var cashLabel: UILabel!
    @IBOutlet var cashLabel2: UILabel!
    @IBOutlet var paymentTextField: UITextField!
    @IBOutlet var cashTextField: UITextField!
    var information = [InformationModel]()
    var newInfo = [InformationModel]()
    var passedNumber2: Int!
    var passedEventName: String!
    var passedDate: String!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.cashTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    func loadData()  {
//        読み込み
        let realm = try! Realm()
        //（realmの）倉庫から丸ごと取ってきた
        let passedInfo = passedEventName!
        let passedDate2 = passedDate!
        let allInfo = realm.objects(InformationModel.self).filter("eventName == %@ && payDate == %@", passedInfo, passedDate2)
//       （Xcode内の）倉庫を初期化
        information = [InformationModel]()
//        倉庫のものを一つづつ取り出してxcode内の倉庫に追加
        for i in allInfo {
            information.append(i)
        }
    }
    
    @IBAction func desideButton() {
        if let cash = Int(cashTextField.text!) {
        //     データの保存
        let realm = try! Realm()
        let memberModel = MemberModel()
        let costNameModel = CostNameModel()
        let costModel = CostModel()
        costModel.cost = Int(cashTextField.text!)!
        costNameModel.costName = paymentTextField.text!
        //Todoの編集
        try! realm.write {
            information[0].member[passedNumber2].costName.append(costNameModel)
            information[0].member[passedNumber2].cost.append(costModel)
            realm.add(information)
        }
        // 1秒後に閉じる
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.navigationController?.popViewController(animated: true)
            }
            success()
        } else {
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "数字を入力してください", preferredStyle:  .alert)
            // ② Actionの設定
            // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
            })
            // ③ UIAlertControllerにActionを追加
            alert.addAction(defaultAction)
            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
        }
    }
    
//    アラート
    func success() {
        KRProgressHUD.showSuccess(withMessage: "支払いが追加されました")
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
           KRProgressHUD.dismiss()
        }
    }
}
