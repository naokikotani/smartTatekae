//
//  InformationModel.swift
//  tatekae
//
//  Created by 小谷直輝 on 2020/10/04.
//  Copyright © 2020 kotaninaoki. All rights reserved.
//

import Foundation
import RealmSwift

class InformationModel: Object {
    @objc dynamic var eventName: String!
    @objc dynamic var payDate: String!
    let member = List<MemberModel>()
}

