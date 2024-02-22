//
//  RecentTransactionButtonView.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit

class TableViewHeaderView: UITableViewHeaderFooterView {

    // MARK: Variables
    
    static let CellID = "TableViewHeaderView"
    
    let headerLabel: UILabel = UILabel().then{
        $0.text = "Recent Transactions"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let buttonView: UIView = UIView().then{
        $0.backgroundColor = .white
    }
    
    let allButton: UIButton = UIButton().then{
        $0.setTitle("All", for: .normal)
        $0.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "#BDBDBD"), for: .disabled)
        $0.backgroundColor = .none
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    let expenseButton: UIButton = UIButton().then{
        $0.setTitle("Expense", for: .normal)
        $0.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "#BDBDBD"), for: .disabled)
        $0.backgroundColor = .none
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    let incomeButton: UIButton = UIButton().then{
        $0.setTitle("Income", for: .normal)
        $0.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "#BDBDBD"), for: .disabled)
        $0.backgroundColor = .none
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpLayout()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    
    func setUpView() {
        self.backgroundColor = .white
    }
    
    
    // MARK: Layout
    
    func setUpLayout() {
        [ headerLabel, buttonView]
            .forEach{ self.addSubview($0)}
        [ allButton, incomeButton, expenseButton]
            .forEach{ self.buttonView.addSubview($0)}
    }
    
    // MARK: Constraint
    
    func setUpConstraint() {
        headerLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(27)
        }
        
        buttonView.snp.makeConstraints{
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(24)
            $0.top.equalTo(headerLabel.snp.bottom).offset(30)
        }
        allButton.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        expenseButton.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(allButton.snp.trailing).offset(25)

        }
        incomeButton.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(expenseButton.snp.trailing).offset(25)
        }
    }
    
    // MARK: Function

}
