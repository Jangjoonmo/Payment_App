//
//  splitTransactionData.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/22/24.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

// MARK: 용량이 큰 Json 파일을 일주일 단위로 입/출금으로 나눠서 데이터 분할

class TransactionManager {
    static let shared = TransactionManager()
    private let realm = try! Realm()

    init() {}
    
    func parseJSON() {
        let url = URL(fileURLWithPath: "/Users/jangjoonmo/Downloads/delightlabs-ios-hometest-mockdata-2024.json")
        do {
            let data = try Data(contentsOf: url)
            let transactions = try JSONDecoder().decode([Transaction].self, from: data)
            
            let realm = try! Realm()
            try! realm.write {
                for transaction in transactions {
                    let transactionData = TransactionData()
                    transactionData.name = transaction.name
                    transactionData.amount = transaction.amount
                    transactionData.timestamp = transaction.timestamp
                    transactionData.type = transaction.type
                    transactionData.transactionType = transaction.amount.hasPrefix("-") ? "expense" : "income"
                    print("transaction: \(transaction)")
                    realm.add(transactionData)
                }
            }
        } catch {
            print(error)
        }
    }

}

extension TransactionManager {

    func getIncomeTransactionsInPastWeek() -> [TransactionData] {
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let transactions = realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'income'", oneWeekAgo)
        return Array(transactions)
    }
    
    // 일주일치 출금 데이터
    func getExpenseTransactionsInPastWeek() -> [TransactionData] {
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let transactions = realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'expense'", oneWeekAgo)
        return Array(transactions)
    }
    
    // 한달치 입금 데이터
    func getIncomeTransactionsInPastMonth() -> [TransactionData] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let transactions = realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'income'", oneMonthAgo)
        return Array(transactions)
    }
    
    // 한달치 출금 데이터
    func getExpenseTransactionsInPastMonth() -> [TransactionData] {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let transactions = realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'expense'", oneMonthAgo)
        return Array(transactions)
    }
    
    // 최근 입출금 내역 20건
    func getLast20Transactions() -> [TransactionData] {
        let transactions = realm.objects(TransactionData.self).sorted(byKeyPath: "timestamp", ascending: false).prefix(20)
        print(transactions.count)
        return Array(transactions)
    }
    
    // 최근 출금 내역 10건
    func getLast10ExpenseTransactions() -> [TransactionData] {
        let transactions = realm.objects(TransactionData.self).filter("transactionType == 'expense'").sorted(byKeyPath: "timestamp", ascending: false).prefix(10)
        return Array(transactions)
    }
    
    // 최근 입금 내역 10건
    func getLast10IncomeTransactions() -> [TransactionData] {
        let transactions = realm.objects(TransactionData.self).filter("transactionType == 'income'").sorted(byKeyPath: "timestamp", ascending: false).prefix(10)
        return Array(transactions)
    }
}
