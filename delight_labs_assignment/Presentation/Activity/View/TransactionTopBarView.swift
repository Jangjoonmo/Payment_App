//
//  TransactionTopBarView.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/23/24.
//

import UIKit

class TransactionTopBarView: UIView {

    // MARK: Variables
    
    static let id = "TransactionTopBarView"
    
    let titleLabel: UILabel = UILabel().then{
        $0.text = "Transactions"
        $0.font = .systemFont(ofSize: 24, weight: .heavy)
        $0.sizeToFit()
    }
    
    let notisButton:UIButton = UIButton().then{
        $0.setImage(UIImage(named: "notis"), for: .normal)
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        [titleLabel, notisButton].forEach{addSubview($0)}
    }
    
    // MARK: Constraint
    
    func setUpConstraint() {
        titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(28)
            $0.top.equalToSuperview().offset(22)
            $0.height.equalTo(36)
        }
        notisButton.snp.makeConstraints{
            $0.size.equalTo(24)
            $0.top.equalToSuperview().offset(29)
            $0.trailing.equalToSuperview().inset(28)
        }
    }
    
    // MARK: Function

}
