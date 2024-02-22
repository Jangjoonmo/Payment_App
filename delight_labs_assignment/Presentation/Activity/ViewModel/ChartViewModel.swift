//
//  ChartViewModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/22/24.
//

import Foundation
import RxSwift
import Charts
import DGCharts
import RealmSwift

class ChartViewModel {
    
    struct Input {
    }
    
    struct Output {
        let chartData: Observable<LineChartData>
    }
    
    func transform(input: Input) -> Output {
        let chartData = fetchChartData().asObservable()
        return Output(chartData: chartData)
    }
    
    private func fetchChartData() -> Single<LineChartData> {
        return Single.create { single in
            let transactionManager = TransactionManager()
            
            let incomeTransactions = transactionManager.getIncomeTransactionsInPastWeek()
            let expenseTransactions = transactionManager.getExpenseTransactionsInPastWeek()
            
            var incomeDataEntries: [ChartDataEntry] = []
            var expenseDataEntries: [ChartDataEntry] = []
            
            for i in 0..<7 {
                let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                dateComponents.hour = 0
                dateComponents.minute = 0
                dateComponents.second = 0
                dateComponents.nanosecond = 0

                if let dailyIncomeTransactions = incomeTransactions[dateComponents] {
                    let dailyIncome = dailyIncomeTransactions.reduce(0) { $0 + Double($1.amount)! }
                    incomeDataEntries.append(ChartDataEntry(x: date.timeIntervalSince1970, y: dailyIncome))
                }

                if let dailyExpenseTransactions = expenseTransactions[dateComponents] {
                    let dailyExpense = dailyExpenseTransactions.reduce(0) { $0 + Double($1.amount)! }
                    expenseDataEntries.append(ChartDataEntry(x: date.timeIntervalSince1970, y: dailyExpense))
                }
            }

            
            print("Income Data Entries: \(incomeDataEntries)") 
            print("Expense Data Entries: \(expenseDataEntries)")
            
            let incomeDataSet = LineChartDataSet(entries: incomeDataEntries, label: "Income")
            incomeDataSet.colors = [NSUIColor.green]
            
            let expenseDataSet = LineChartDataSet(entries: expenseDataEntries, label: "Expense")
            expenseDataSet.colors = [NSUIColor.blue]
            
            let chartData = LineChartData(dataSets: [incomeDataSet, expenseDataSet])
            
            single(.success(chartData))
            
            return Disposables.create {}
        }
    }


}
