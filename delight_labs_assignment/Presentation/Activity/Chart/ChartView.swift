//
//  ChartView.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/22/24.
//

import UIKit
import Charts
import DGCharts
import RealmSwift

class ChartView: UIView {
    
    let lineChartView = LineChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLineChartView()
        fetchDataAndDrawChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLineChartView()
        fetchDataAndDrawChart()
    }
    
    private func setupLineChartView() {
        lineChartView.frame = self.bounds
        lineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(lineChartView)
    }
    
    private func fetchDataAndDrawChart() {
        let realm = try! Realm()
        
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let incomeTransactions = Array(realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'income'", oneWeekAgo))
        let expenseTransactions = Array(realm.objects(TransactionData.self).filter("timestamp >= %@ AND transactionType == 'expense'", oneWeekAgo))
        
        var incomeDataEntries: [ChartDataEntry] = []
        var expenseDataEntries: [ChartDataEntry] = []
        
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            
            let dailyIncomeTransactions = incomeTransactions.filter { stringToDate($0.timestamp).startOfDay() == date.startOfDay() }
            let dailyIncome = dailyIncomeTransactions.reduce(0) { $0 + Double($1.amount)! }
            incomeDataEntries.append(ChartDataEntry(x: Double(i), y: dailyIncome))
            
            let dailyExpenseTransactions = expenseTransactions.filter { stringToDate($0.timestamp).startOfDay() == date.startOfDay() }
            let dailyExpense = dailyExpenseTransactions.reduce(0) { $0 + Double($1.amount)! }
            expenseDataEntries.append(ChartDataEntry(x: Double(i), y: dailyExpense))
        }
        
        let incomeDataSet = LineChartDataSet(entries: incomeDataEntries, label: "Income")
        incomeDataSet.colors = [NSUIColor.green]
        
        let expenseDataSet = LineChartDataSet(entries: expenseDataEntries, label: "Expense")
        expenseDataSet.colors = [NSUIColor.blue]
        
        let chartData = LineChartData(dataSets: [incomeDataSet, expenseDataSet])
        lineChartView.data = chartData
        
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    private func stringToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: string) ?? Date()
    }
}

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
