//
//  RentInformationModel.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/10/07.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import Foundation
import RealmSwift

class RentInformationModel: Object {
    @objc dynamic var person: String!
    @objc dynamic var cash = 0
    @objc dynamic var select: String!
    @objc dynamic var deadLine: String!
    @objc dynamic var memo: String!
}

