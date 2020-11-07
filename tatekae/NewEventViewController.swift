//
//  NewEventViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/24.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift

class NewEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var newEventNameTextField: UITextField!
    @IBOutlet var addMemberTablevView: UITableView!
    @IBOutlet var dateTextField: UITextField!
    var addMemberTextField: UITextField!
    var newMemberArray: [String] = []
    var infoArray = [InformationModel]()
    var datePicker: UIDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        addMemberTablevView.delegate = self
        addMemberTablevView.dataSource = self
        //        空のセルのセパレーターを消す
        addMemberTablevView.tableFooterView = UIView(frame: .zero)
        // カスタムセルの登録
        addMemberTablevView.register(UINib(nibName: "NewEventViewControllerTableViewCell", bundle: nil),forCellReuseIdentifier:"newEventViewControllerTableViewCell")
        
//      ピッカー
        // ピッカー設定
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateTextField.inputView = datePicker
            
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
            
            // インプットビュー設定
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
    }
    
//    ピッカー以外の部分に触れるとピッカーを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // ピッカーの決定ボタン
    @objc func done() {
           dateTextField.endEditing(true)
           // 日付のフォーマット
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           dateTextField.text = "\(formatter.string(from: datePicker.date))"
       }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "newEventViewControllerTableViewCell", for: indexPath) as! NewEventViewControllerTableViewCell
        // セルに表示する値を設定する
        cell.memberNameLabel!.text = newMemberArray[indexPath.row]
        return cell
        }
           
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newMemberArray.count
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    メンバー追加ボタンが押された時の処理
    @IBAction func addMemberButton() {
//        アラート
        let alert: UIAlertController = UIAlertController(title: "メンバーの追加", message: "メンバーを追加してください", preferredStyle:  .alert)
        // ② Actionの設定
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            
            if self.addMemberTextField.text!.count >= 1 {
                self.newMemberArray.append(self.addMemberTextField.text!)
                self.addMemberTablevView.reloadData()
            } else {
            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        // テキストフィールドの追加
        alert.addTextField { (textField) in
                textField.placeholder = "名前"
                self.addMemberTextField = textField
        }
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    // segueが動作することをViewControllerに通知するメソッド
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // segueのIDを確認して特定のsegueのときのみ動作させる
           if segue.identifier == "toMemberViewContloller" {
                // 2. 遷移先のViewControllerを取得
                let next = segue.destination as? MemberViewController
                // 3. １で用意した遷移先の変数に値を渡す
                next?.passedEventName = self.newEventNameTextField.text
                next?.passedEventDate = self.dateTextField.text
                next?.navigationText = self.newEventNameTextField.text
            }
       }
    
       @IBAction func tapTransitionButton(_ sender: Any) {
        if newMemberArray.count >= 1 && newEventNameTextField.text!.count >= 1 && dateTextField.text!.count >= 1 {
            
//           データの保存
            let realm = try! Realm()
            let infoModel = InformationModel()
            
            infoModel.eventName = self.newEventNameTextField.text!
            infoModel.payDate = self.dateTextField.text!
        
            for r in 0 ..<  self.newMemberArray.count {
                let memberModel = MemberModel()
                memberModel.member = newMemberArray[r]
                infoModel.member.append(memberModel)
            }
                       
            //Todoの編集
            try! realm.write {
                realm.add(infoModel)
            }
           // 4. 画面遷移実行
            self.performSegue(withIdentifier: "toMemberViewContloller", sender: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "必要事項が追加されていません", preferredStyle:  .alert)
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
}
