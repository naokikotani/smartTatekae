//
//  ViewControllerTableViewCell.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/10/25.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet var EventNameLabel: UILabel!
    @IBOutlet var EventDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
