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
        DispatchQueue.main.async {
            let url = URL(fileURLWithPath: "/Users/jangjoonmo/Downloads/delightlabs-ios-hometest-mockdata-2024.json")
            do {
                let data = try Data(contentsOf: url)
                let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                let transactionDataList = transactions.map { transaction -> TransactionData in
                    let transactionData = TransactionData()
                    transactionData.name = transaction.name
                    transactionData.amount = transaction.amount
                    if let date = dateFormatter.date(from: transaction.timestamp) {
                        transactionData.timestamp = date
                    }
                    transactionData.type = transaction.type
                    transactionData.transactionType = transaction.amount.hasPrefix("-") ? "expense" : "income"
                    return transactionData
                }
                
                try! self.realm.write {
                    for batch in transactionDataList.chunks(of: 1000) {  // Change this to a suitable batch size
                        self.realm.add(batch)
                    }
                }
            } catch {
                print(error)
            }
        }
    }

}

extension TransactionManager {
    
    // 일주일치 입금 데이터
    func getIncomeTransactionsInPastWeek() -> [DateComponents: [TransactionData]] {
        print("일주일치 입금 데이터 트랜잭션 매니저 실행")
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let transactions = realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'income'", oneWeekAgo)
        let groupedTransactions = Dictionary(grouping: Array(transactions), by: { $0.dateComponents })
        return groupedTransactions
    }

    // 일주일치 출금 데이터
    func getExpenseTransactionsInPastWeek() -> [DateComponents: [TransactionData]] {
        print("일주일치 출금 데이터 트랜잭션 매니저 실행")
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let transactions = realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'expense'", oneWeekAgo)
        let groupedTransactions = Dictionary(grouping: Array(transactions), by: { $0.dateComponents })
        print("일주일치 출금 데이터 트랜잭션 매니저 완료")
        return groupedTransactions
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
        let transactions = realm.objects(TransactionData.self)
            .sorted(byKeyPath: "timestamp", ascending: false)
            .prefix(20)
        return Array(transactions)
    }
    
    // 최근 출금 내역 10건
    func getLast10ExpenseTransactions() -> [TransactionData] {
        let transactions = realm.objects(TransactionData.self)
            .filter("transactionType == 'expense'")
            .sorted(byKeyPath: "timestamp", ascending: false)
            .prefix(10)
        return Array(transactions)
    }
    
    // 최근 입금 내역 10건
    func getLast10IncomeTransactions() -> [TransactionData] {
        let transactions = realm.objects(TransactionData.self)
            .filter("transactionType == 'income'")
            .sorted(byKeyPath: "timestamp", ascending: false)
            .prefix(10)
        return Array(transactions)
    }
}
