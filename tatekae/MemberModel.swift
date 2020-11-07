//
//  MemberModel.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/10/15.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import Foundation
import RealmSwift

class MemberModel: Object {
    @objc dynamic var member: String!
    @objc dynamic var difference: Int = 0
    let cost = List<CostModel>()
    let costName = List<CostNameModel>()
}

class CostModel: Object {
    @objc dynamic var cost: Int = 0
}

class CostNameModel: Object {
    @objc dynamic var costName: String!
}
