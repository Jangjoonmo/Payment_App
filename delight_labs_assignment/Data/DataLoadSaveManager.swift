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
enum DataLoadSaveError: Error {
    case objectDeallocated
    case alreadyInProgress
}

class DataLoadSaveManager {
    
    static let shared = DataLoadSaveManager()
    private let dataLoadSubject = BehaviorSubject<Bool>(value: false)
    
    var isDataLoaded: Observable<Bool> {
        return dataLoadSubject.asObservable()
    }
    
    func loadAndSaveDataIfNeeded() {
        let defaults = UserDefaults.standard
        let didLoadAndSaveData = defaults.bool(forKey: "didLoadAndSaveData")
        
        if didLoadAndSaveData {
            dataLoadSubject.onNext(true)
            return
        }
        
        loadAndSaveData()
        
        defaults.set(true, forKey: "didLoadAndSaveData")
        dataLoadSubject.onNext(true)
    }
    
}
func loadAndSaveData() {
    // 원본 JSON 데이터 로드
    let url = URL(fileURLWithPath: "/Users/jangjoonmo/Downloads/delightlabs-ios-hometest-mockdata-2024.json")
    let data = try! Data(contentsOf: url)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    let transactions = try! decoder.decode([Transaction].self, from: data)
    
    // Realm 객체를 가져옵니다.
    let realm = try! Realm()

    // 각 거래에 대해 TransactionData 객체를 생성하고 저장합니다.
    for transaction in transactions {
        let transactionData = TransactionData()
        transactionData.name = transaction.name
        transactionData.amount = transaction.amount
        transactionData.timestamp = transaction.timestamp
        transactionData.type = transaction.type
        transactionData.transactionType = transaction.amount.hasPrefix("+") ? "income" : "expense"

        // TransactionData 객체를 Realm에 저장합니다.
        try! realm.write {
            realm.add(transactionData)
        }
    }
}

func loadAndSaveDataIfNeeded() {
    let defaults = UserDefaults.standard
    let didLoadAndSaveData = defaults.bool(forKey: "didLoadAndSaveData")

    // 데이터가 이미 로드되었고 저장되었으면 함수를 종료합니다.
    if didLoadAndSaveData {
        return
    }

    // 원본 JSON 데이터를 로드하고 저장합니다.
    loadAndSaveData()

    // 데이터 로드 및 저장 상태를 저장합니다.
    defaults.set(true, forKey: "didLoadAndSaveData")
}

// 최근 일주일치 입금 데이터
func getWeeklyIncomes() -> Results<TransactionData> {
    let realm = try! Realm()
    let date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
    let incomes = realm.objects(TransactionData.self).filter("transactionType = 'income' AND timestamp >= %@", date).sorted(byKeyPath: "timestamp", ascending: false)
    return incomes
}

// 최근 일주일치 출금 데이터
func getWeeklyExpenses() -> Results<TransactionData> {
    let realm = try! Realm()
    let date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
    let expenses = realm.objects(TransactionData.self).filter("transactionType = 'expense' AND timestamp >= %@", date).sorted(byKeyPath: "timestamp", ascending: false)
    return expenses
}

// 최근 한달치 입금 데이터
func getMonthlyIncomes() -> Results<TransactionData> {
    let realm = try! Realm()
    let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    let incomes = realm.objects(TransactionData.self).filter("transactionType = 'income' AND timestamp >= %@", date).sorted(byKeyPath: "timestamp", ascending: false)
    return incomes
}

// 최근 한달치 출금 데이터
func getMonthlyExpenses() -> Results<TransactionData> {
    let realm = try! Realm()
    let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    let expenses = realm.objects(TransactionData.self).filter("transactionType = 'expense' AND timestamp >= %@", date).sorted(byKeyPath: "timestamp", ascending: false)
    return expenses
}

// 최근 입출금 내역 20건
func getRecentTransactions() -> Array<TransactionData> {
    let realm = try! Realm()
    let transactions = realm.objects(TransactionData.self).sorted(byKeyPath: "timestamp", ascending: false).prefix(20)
    return Array(transactions)
}

// 최근 출금 내역 10건
func getRecentExpenses() -> Array<TransactionData> {
    let realm = try! Realm()
    let expenses = realm.objects(TransactionData.self).filter("transactionType = 'expense'").sorted(byKeyPath: "timestamp", ascending: false).prefix(10)
    return Array(expenses)
}

// 최근 입금 내역 10건
func getRecentIncomes() -> Array<TransactionData> {
    let realm = try! Realm()
    let incomes = realm.objects(TransactionData.self).filter("transactionType = 'income'").sorted(byKeyPath: "timestamp", ascending: false).prefix(10)
    return Array(incomes)
}
