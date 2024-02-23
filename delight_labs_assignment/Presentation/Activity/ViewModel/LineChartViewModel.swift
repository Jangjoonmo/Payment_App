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
    
//    private let disposeBag = DisposeBag()
    
    @Published var incomeData: [Double] = []
    @Published var expenseData: [Double] = []
    @Published var isLoading = false
    
    init() {
        fetchTransactions(period: 7)
    }
    
    func fetchTransactions(period: Int) {
        DispatchQueue.main.async
        { [self] in
            isLoading = true  // 로딩 시작
            let incomeTransactions: [DateComponents: [TransactionData]]
            let expenseTransactions: [DateComponents: [TransactionData]]
            
            var interval: Int
            
            if period == 7 {
                incomeTransactions = TransactionManager.shared.getIncomeTransactionsInPastWeek()
                expenseTransactions = TransactionManager.shared.getExpenseTransactionsInPastWeek()
                interval = 1    //1시간 간격
            } else { // 30일
                incomeTransactions = TransactionManager.shared.getIncomeTransactionsInPastMonth()
                expenseTransactions = TransactionManager.shared.getExpenseTransactionsInPastMonth()
                interval = 8    // 3시간 간격
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
            isLoading = false  // 로딩 종료
        }
    } // end of fetchTransactions

}// end of ViewModel
