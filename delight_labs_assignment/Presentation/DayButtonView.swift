//
//  DayButtonView.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit
import SnapKit
import Then

class TopView: UIView {
    
    let buttonView: UIView = UIView().then{
        $0.backgroundColor = .black // F5F5F5로 변경
    }

    let weekButton: UIButton = UIButton().then{
        $0.setTitle("Week", for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.gray, for: .disabled) // #363062
        
        $0.configuration = UIButton.Configuration.bordered()
    }
    
    let monthButton: UIButton = UIButton().then{
        $0.setTitle("Month", for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.setTitleColor(.gray, for: .disabled) // #363062

        $0.configuration = UIButton.Configuration.bordered()
    }
    
    let dateLabel: UILabel = UILabel().then{
        $0.text = "MM DD, YYYY"
        $0.sizeToFit()
    }
    
    let incomeView: UIView = UIView().then{
        $0.backgroundColor = .blue // #363062
    }
    
    let incomeLabel: UILabel = UILabel().then{
        $0.text = "Income"
        $0.sizeToFit()
    }
    
    let expenseView: UIView = UIView().then{
        $0.backgroundColor = .blue // #363062
    }
    
    let expenseLabel: UILabel = UILabel().then{
        $0.text = "Expense"
        $0.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .black // F5F5F5로 변경
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
            $0.top.trailing.equalToSuperview()
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
            $0.top.equalTo(buttonView.snp.bottom).offset(9)
        }
        
        expenseView.snp.makeConstraints{
            $0.size.equalTo(incomeView)
            $0.leading.equalTo(incomeLabel.snp.trailing).offset(20)
            $0.bottom.equalTo(incomeView)
        }
        
        expenseLabel.snp.makeConstraints{
            $0.leading.equalTo(expenseView.snp.trailing).offset(9)
            $0.top.equalTo(incomeLabel)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
