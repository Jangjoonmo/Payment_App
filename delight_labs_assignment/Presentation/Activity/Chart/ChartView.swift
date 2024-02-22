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
import RxSwift

class ChartView: UIView {
    
    let lineChartView = LineChartView()
    var chartViewModel: ChartViewModel!
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        chartViewModel = ChartViewModel()
        setupLineChartView()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        chartViewModel = ChartViewModel()
        setupLineChartView()
        bindViewModel()
    }
    
    private func setupLineChartView() {
        lineChartView.frame = self.bounds
        lineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(lineChartView)
    }
    
    private func bindViewModel() {
        let input = ChartViewModel.Input()
        let output = chartViewModel.transform(input: input)
        
        output.chartData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] chartData in
                self?.lineChartView.data = chartData
                print(chartData)
                self?.lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            }).disposed(by: disposeBag)
    }

}

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
