//
//  RentTableViewCell.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/09/29.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import UIKit

class RentTableViewCell: UITableViewCell {
    
    @IBOutlet var deadLineLabel: UILabel!
    @IBOutlet var deadLineLabel2: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cashLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
