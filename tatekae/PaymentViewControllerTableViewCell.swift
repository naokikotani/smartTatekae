//
//  PaymentViewControllerTableViewCell.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/10/27.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit

class PaymentViewControllerTableViewCell: UITableViewCell {

    @IBOutlet var costNameLabel: UILabel!
    @IBOutlet var costLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
