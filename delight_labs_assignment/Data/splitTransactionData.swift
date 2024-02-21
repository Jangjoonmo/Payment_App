//
//  splitTransactionData.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/22/24.
//

import Foundation

// MARK: 용량이 큰 Json 파일을 일주일 단위로 입/출금으로 나눠서 데이터 분할

func splitDataIntoWeeklyBatches() {
    // 원본 JSON 데이터 로드
    let url = URL(fileURLWithPath: "/Users/jangjoonmo/Downloads/delightlabs-ios-hometest-mockdata-2024.json")
    let data = try! Data(contentsOf: url)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    let transactions = try! decoder.decode([Transaction].self, from: data)

    let calendar = Calendar.current

    // 일주일 단위로 데이터 분류
    var weeklyIncomeData: [String: [Transaction]] = [:]
    var weeklyExpenseData: [String: [Transaction]] = [:]
    var latestTransactions: [Transaction] = []

    for transaction in transactions {
        let weekOfYear = calendar.component(.weekOfYear, from: transaction.timestamp)
        let year = calendar.component(.year, from: transaction.timestamp)
        let weekKey = "\(year)-\(weekOfYear)"
        
        if transaction.amount.hasPrefix("+") {  // 수입
            if weeklyIncomeData[weekKey] == nil {
                weeklyIncomeData[weekKey] = []
            }
            weeklyIncomeData[weekKey]!.append(transaction)
        } else if transaction.amount.hasPrefix("-") {  // 지출
            if weeklyExpenseData[weekKey] == nil {
                weeklyExpenseData[weekKey] = []
            }
            weeklyExpenseData[weekKey]!.append(transaction)
        }
    }

    // 가장 최근의 20개 거래 저장
    latestTransactions = Array(transactions.suffix(20))

    // 각 일주일 단위의 데이터를 별도의 JSON 파일로 저장
    for (weekKey, transactions) in weeklyIncomeData {
        saveTransactionsToFile(transactions, fileName: "income-\(weekKey).json")
    }

    for (weekKey, transactions) in weeklyExpenseData {
        saveTransactionsToFile(transactions, fileName: "expense-\(weekKey).json")
    }

    // 최근의 20개 거래를 별도의 JSON 파일로 저장
    saveTransactionsToFile(latestTransactions, fileName: "latestTransactions.json")
}

func saveTransactionsToFile(_ transactions: [Transaction], fileName: String) {
    let data = try! JSONEncoder().encode(transactions)
    let url = getDocumentsDirectory().appendingPathComponent(fileName)
    try! data.write(to: url)
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
