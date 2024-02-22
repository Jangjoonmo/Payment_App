//
//  LineChartViewModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class LineChartViewModel: ObservableObject {
    
    private let disposeBag = DisposeBag()
    
    @Published var incomeData: [Double] = []
    @Published var expenseData: [Double] = []
    
    private let incomeSubject = BehaviorSubject<[Double]>(value: [])
    private let expenseSubject = BehaviorSubject<[Double]>(value: [])
    
    
    var incomeObservable: Observable<[Double]> {
        return incomeSubject.asObservable()
    }
    
    var expenseObservable: Observable<[Double]> {
        return expenseSubject.asObservable()
    }
    
    init() {
        fetchTransactions(period: 7)
    }
    
    func fetchTransactions(period: Int) {
        let incomeTransactions: [DateComponents: [TransactionData]]
        let expenseTransactions: [DateComponents: [TransactionData]]
        
        var interval: Int
        
        if period == 7 {
            incomeTransactions = TransactionManager.shared.getIncomeTransactionsInPastWeek()
            expenseTransactions = TransactionManager.shared.getExpenseTransactionsInPastWeek()
            interval = 1
        } else { // 30일
            incomeTransactions = TransactionManager.shared.getIncomeTransactionsInPastMonth()
            expenseTransactions = TransactionManager.shared.getExpenseTransactionsInPastMonth()
            interval = 3
        }
        
        var incomeValues: [Double] = []
        var expenseValues: [Double] = []
        
        for i in 0..<period {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            
            for hour in stride(from: 0, to: 24, by: interval) {
                dateComponents.hour = hour
                dateComponents.minute = 0
                dateComponents.second = 0
                dateComponents.nanosecond = 0

                if let transactions = incomeTransactions[dateComponents], !transactions.isEmpty {
                    let income = Double(transactions[0].amount)?.rounded(toPlaces: 1) ?? 0.0
                    incomeValues.append(income)
                }

                if let transactions = expenseTransactions[dateComponents], !transactions.isEmpty {
                    let expense = abs(Double(transactions[0].amount)?.rounded(toPlaces: 1) ?? 0.0)
                    expenseValues.append(expense)
                }
            }
        }

        
        incomeData = incomeValues
        expenseData = expenseValues
        
        incomeSubject.onNext(incomeValues)
        expenseSubject.onNext(expenseValues)
    }

}
