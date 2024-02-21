//
//  TransactionModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import Foundation

struct Transaction: Codable {
    let name: String
    let amount: String
    let timestamp: String
    let type: String
}
