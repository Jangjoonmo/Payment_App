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
        fetchTransactions()
    }
    
    private func fetchTransactions() {
        let incomeTransactions = TransactionManager.shared.getIncomeTransactionsInPastWeek()
        let expenseTransactions = TransactionManager.shared.getExpenseTransactionsInPastWeek()

        var incomeValues: [Double] = []
        var expenseValues: [Double] = []

        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.second = 0
            dateComponents.nanosecond = 0

            if let dailyIncomeTransactions = incomeTransactions[dateComponents] {
                let dailyIncome = dailyIncomeTransactions.reduce(0) { $0 + Double($1.amount)! }
                incomeValues.append(dailyIncome)
            }

            if let dailyExpenseTransactions = expenseTransactions[dateComponents] {
                let dailyExpense = dailyExpenseTransactions.reduce(0) { $0 + abs(Double($1.amount)!) }
                expenseValues.append(dailyExpense)
            }
        }

        
        incomeData = incomeValues
        expenseData = expenseValues

        
        incomeSubject.onNext(incomeValues)
        expenseSubject.onNext(expenseValues)
    }


}
