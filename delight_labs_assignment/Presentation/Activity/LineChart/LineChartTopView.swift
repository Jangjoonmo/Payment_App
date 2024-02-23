//
//  DayButtonView.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

class LineChartTopView: UIView {
    
    //MARK: Variables
    
    var viewModel = LineChartViewModel()
    let disposeBag = DisposeBag()
    
    let buttonView: UIView = UIView().then{
//        $0.backgroundColor = UIColor(hexCode: "F5F5F5")
        $0.backgroundColor = .white

    }
    
    let weekButton: UIButton = UIButton().then{
        $0.setTitle("Week", for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.backgroundColor = UIColor(named: "MainColor") // #363062
        $0.setTitleColor(UIColor(hexCode: "#6B6B6B"), for: .normal)
        
        $0.configuration = UIButton.Configuration.bordered()
        
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    let monthButton: UIButton = UIButton().then{
        $0.setTitle("Month", for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(UIColor(hexCode: "#6B6B6B"), for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor")

        $0.configuration = UIButton.Configuration.bordered()
        
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    let dateLabel: UILabel = UILabel().then{
        $0.text = "MM DD, YYYY"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "MainColor")
        $0.sizeToFit()
    }
    
    let incomeView: UIView = UIView().then{
        $0.backgroundColor = UIColor(named: "MainColor") // #363062
    }
    
    let incomeLabel: UILabel = UILabel().then{
        $0.text = "Income"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "MainColor")
        $0.sizeToFit()
    }
    
    let expenseView: UIView = UIView().then{
        $0.backgroundColor = UIColor(named: "GreenColor") // #5BDAA4
    }
    
    let expenseLabel: UILabel = UILabel().then{
        $0.text = "Expense"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "MainColor")
        $0.sizeToFit()
    }
    
    //MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        bindViewModel()
    }
    
    //MARK: setUI()
    
    private func setUI() {
        self.backgroundColor = .white
        [buttonView, dateLabel, incomeView, incomeLabel, expenseView, expenseLabel]
            .forEach{ self.addSubview($0)}
        
        [weekButton, monthButton]
            .forEach{buttonView.addSubview($0)}
        
        buttonView.snp.makeConstraints{
            $0.width.equalTo(172)
            $0.height.equalTo(34)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints{
            $0.centerY.equalTo(buttonView)
            $0.trailing.equalToSuperview()
        }
        
        weekButton.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(86)
            $0.height.equalTo(34)
        }
        
        monthButton.snp.makeConstraints{
            $0.leading.equalTo(weekButton.snp.trailing)
            $0.top.bottom.equalTo(weekButton)
            $0.size.equalTo(weekButton)
        }
        
        incomeView.snp.makeConstraints{
            $0.width.equalTo(32)
            $0.height.equalTo(5)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7)
        }
        
        incomeLabel.snp.makeConstraints{
            $0.leading.equalTo(incomeView.snp.trailing).offset(9)
            $0.centerY.equalTo(incomeView)
        }
        
        expenseView.snp.makeConstraints{
            $0.size.equalTo(incomeView)
            $0.leading.equalTo(incomeLabel.snp.trailing).offset(20)
            $0.bottom.equalTo(incomeView)
        }
        
        expenseLabel.snp.makeConstraints{
            $0.leading.equalTo(expenseView.snp.trailing).offset(9)
            $0.centerY.equalTo(incomeLabel)
            
        }
    }
    
    // MARK: BindViewModel
    
    private func bindViewModel() {
        weekButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, !self.weekButton.isSelected else { return }
                self.weekButton.isSelected = true
                self.weekButton.backgroundColor = UIColor(named: "MainColor")
                self.monthButton.isSelected = false
                self.monthButton.backgroundColor = UIColor(hexCode: "#F5F5F5")
                self.viewModel.fetchTransactions(period: 7)

            })
            .disposed(by: disposeBag)
        
        monthButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, !self.monthButton.isSelected else { return }
                self.monthButton.isSelected = true
                self.weekButton.isSelected = false
                self.monthButton.backgroundColor = UIColor(named: "MainColor")
                self.weekButton.backgroundColor = UIColor(hexCode: "#F5F5F5")
                self.viewModel.fetchTransactions(period: 30)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
