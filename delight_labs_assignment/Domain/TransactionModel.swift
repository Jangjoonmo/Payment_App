//
//  TransactionModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import Foundation
import RealmSwift

struct Transaction: Codable {
    let name: String
    let amount: String
    let timestamp: Date
    let type: String
}

class TransactionData: Object {
    @objc dynamic var name = ""
    @objc dynamic var amount = ""
    @objc dynamic var timestamp = Date()
    @objc dynamic var type = "" // transfer 고정
    @objc dynamic var transactionType = "" // income 또는 expense
}
