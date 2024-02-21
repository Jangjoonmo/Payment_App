//
//  TransactionTableViewCell.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    //MARK: Variables
    
    static let cellID = "TransactionTableViewCell"
    
    let symbolImageView: UIImageView = UIImageView().then{
        $0.backgroundColor = UIColor(hexCode: "#E2E2E2")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    var nameLabel: UILabel = UILabel().then{
        $0.text = "Name"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.sizeToFit()
    }
    
    var typeLabel: UILabel = UILabel().then{
        $0.text = "Transfer"
        $0.textColor = UIColor(hexCode: "#6B6B6B")
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.sizeToFit()
    }
    
    var amountLabel: UILabel = UILabel().then{
        $0.text = "+$432.9"
        $0.font = .systemFont(ofSize: 16, weight: .heavy)
        $0.textColor = UIColor(named: "MainColor")
        $0.textAlignment = .right
        $0.sizeToFit()
    }
    
    var timeStampLabel: UILabel = UILabel().then{
        $0.text = "3.30 AM"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(hexCode: "#6B6B6B")
        $0.textAlignment = .right
        $0.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpLayout()
        setUpConstraint()
    }
    
    // MARK: View
    
    private func setUpView() {
        self.selectionStyle = .none
    }
    
    // MARK: Layout
    
    private func setUpLayout() {
        [ symbolImageView, nameLabel, typeLabel, amountLabel, timeStampLabel ]
            .forEach{ self.contentView.addSubview($0)}
    }
    
    
    // MARK: Constraint
    
    private func setUpConstraint() {
        symbolImageView.snp.makeConstraints{
            $0.size.equalTo(51)
            $0.leading.top.bottom.equalToSuperview()
        }
        nameLabel.snp.makeConstraints{
            $0.leading.equalTo(symbolImageView.snp.trailing).offset(20)
            $0.height.equalTo(24)
            $0.top.equalToSuperview().inset(2.5)
        }
        typeLabel.snp.makeConstraints{
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(21)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(1)
        }
        amountLabel.snp.makeConstraints{
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview()
        }
        timeStampLabel.snp.makeConstraints{
            $0.centerY.equalTo(typeLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    // MARK: Func
    
    func configure(_ transaction: TransactionData) {
        nameLabel.text = transaction.name
        typeLabel.text = transaction.type
        let amount = Double(transaction.amount) ?? 0.0
        let amountToString = String(format: "%.1f", abs(amount)) // 절댓값으로 변환
        amountLabel.text = amount < 0 ? "-$\(amountToString)" : "+$\(amountToString)"
        timeStampLabel.text = timestampFormat(transaction.timestamp)
    }

    private func timestampFormat(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h.mm a" // 출력 형식 설정
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        
        return outputFormatter.string(from: date) // 문자열로 변환 후 반환
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//#if DEBUG
//import SwiftUI
//
//@available(iOS 13.0, *)
//struct TransactionTableViewCell_Preview: PreviewProvider {
//    static var previews: some View {
//        UIViewPreview {
//            let cell = TransactionTableViewCell()
//            return cell
//        }
//        .previewLayout(.sizeThatFits)
//        .padding(10)
//    }
//}
//#endif
