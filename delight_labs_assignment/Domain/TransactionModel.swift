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
    let timestamp: String
    let type: String
}

class TransactionData: Object {
    @objc dynamic var name = ""
    @objc dynamic var amount = ""
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var type = "" // transfer 고정
    @objc dynamic var transactionType = "" // income 또는 expense

    
    override static func indexedProperties() -> [String] {
        return ["timestamp", "transactionType"]
    }
    
    convenience init(from transaction: Transaction) {
        self.init()
        
        self.name = transaction.name
        self.amount = transaction.amount
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"  
        if let date = dateFormatter.date(from: transaction.timestamp) {
            self.timestamp = date
        }
        
        self.type = transaction.type
        
        if transaction.amount.hasPrefix("-") {
            self.transactionType = "expense"
        } else {
            self.transactionType = "income"
        }
    }
}

extension TransactionData {
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: timestamp)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.nanosecond = 0
        return dateComponents
    }
}
