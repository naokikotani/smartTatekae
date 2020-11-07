//
//  MemberTableViewCell.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/27.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit

protocol MemberTableViewCellDelegate {
    func tapAddPaymentButton(tableViewCell: UITableViewCell, button: UIButton)
}

class MemberTableViewCell: UITableViewCell{
    
    var delegate : MemberTableViewCellDelegate?
    @IBOutlet var addPaymentButton: UIButton!
    @IBOutlet var memberNameLabel: UILabel!
    @IBOutlet var paymentLabel: UILabel!
    @IBOutlet var paymentLabel2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func puton(button: UIButton) {
        self.delegate?.tapAddPaymentButton(tableViewCell: self, button: button)
        
    }
}
