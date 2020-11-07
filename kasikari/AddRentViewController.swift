//
//  AddRentViewController.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/29.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD

class AddRentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var cashTextField: UITextField!
    @IBOutlet var selectTextField: UITextField!
    @IBOutlet var deadlineTextField: UITextField!
    @IBOutlet var memoTextField: UITextField!
    var datePicker: UIDatePicker = UIDatePicker()
    var pickerView: UIPickerView = UIPickerView()
    let list: [String] = ["借りている", "貸している"]

    override func viewDidLoad() {
        super.viewDidLoad()
        selectPicker()
        picker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.cashTextField.keyboardType = UIKeyboardType.numberPad
    }
    
//    ピッカー以外の部分に触れるとピッカーを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
//    返済期限のピッカー
    func picker() {
        // ピッカー設定
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        deadlineTextField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        deadlineTextField.inputView = datePicker
        deadlineTextField.inputAccessoryView = toolbar
    }
    
        // ピッカーの決定ボタン
        @objc func done() {
           deadlineTextField.endEditing(true)
           // 日付のフォーマット
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           deadlineTextField.text = "\(formatter.string(from: datePicker.date))"
       }
    
    
//    貸し借りの選択をするピッカー
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // ドラムロールに表示する値（文字列）をここで返します
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,forComponent component: Int, reusing view: UIView?) -> UIView{
        let label = UILabel()
        label.text = list[row]
        label.textAlignment = NSTextAlignment.center
        return label
       }
    
    func selectPicker() {
        // ピッカー設定
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deside))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        selectTextField.inputView = pickerView
        selectTextField.inputAccessoryView = toolbar
    }
    
    // 決定ボタン押下
       @objc func deside() {
           selectTextField.endEditing(true)
           selectTextField.text = "\(list[pickerView.selectedRow(inComponent: 0)])"
       }
    
    @IBAction func disideButton() {
        
        if nameTextField.text!.count >= 1 && cashTextField.text!.count >= 1 && selectTextField.text!.count >= 1 && deadlineTextField.text!.count >= 1 && memoTextField.text!.count >= 1, let cash = Int(cashTextField.text!) {
    //           データの保存
            let realm = try! Realm()
            let infoModel = RentInformationModel()
            
            infoModel.person = self.nameTextField.text!
            infoModel.cash = Int(self.cashTextField.text!)!
            infoModel.deadLine = self.deadlineTextField.text!
            infoModel.select = self.selectTextField.text!
            infoModel.memo = memoTextField.text!
        
            //Todoの編集
            try! realm.write {
                realm.add(infoModel)
            }
            
            success()
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            // 閉じる
                self.navigationController?.popViewController(animated: true)
                }
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
    func success() {
        KRProgressHUD.showSuccess(withMessage: "貸し借りが追加されました")
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
           KRProgressHUD.dismiss()
        }
    }
}
