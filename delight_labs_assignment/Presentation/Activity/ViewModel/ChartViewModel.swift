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
                
                let dailyIncomeTransactions = incomeTransactions.filter { $0.timestamp.startOfDay() == date.startOfDay() }
                let dailyIncome = dailyIncomeTransactions.reduce(0) { $0 + Double($1.amount)! }
                incomeDataEntries.append(ChartDataEntry(x: Double(i), y: dailyIncome))
                
                let dailyExpenseTransactions = expenseTransactions.filter { $0.timestamp.startOfDay() == date.startOfDay() }
                let dailyExpense = dailyExpenseTransactions.reduce(0) { $0 + Double($1.amount)! }
                expenseDataEntries.append(ChartDataEntry(x: Double(i), y: dailyExpense))
            }
            
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
