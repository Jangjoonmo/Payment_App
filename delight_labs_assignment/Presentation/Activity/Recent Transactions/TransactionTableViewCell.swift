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
        $0.font = .systemFont(ofSize: 16, weight: .bold)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    // MARK: View
    
    private func setUpView() {
        self.selectionStyle = .none
    }
    
    // MARK: Layout
    
    private func setUpLayout() {
        [ symbolImageView, nameLabel, typeLabel, amountLabel, timeStampLabel ]
            .forEach{ contentView.addSubview($0)}
    }
    
    
    // MARK: Constraint
    
    private func setUpConstraint() {

        symbolImageView.snp.makeConstraints{
            $0.width.equalTo(51)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(28)
        }
        nameLabel.snp.makeConstraints{
            $0.leading.equalTo(symbolImageView.snp.trailing).offset(28)
            $0.trailing.equalTo(amountLabel.snp.leading).offset(1)
            $0.top.equalToSuperview().inset(2.5)
        }
        typeLabel.snp.makeConstraints{
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(2.5)
            $0.top.equalTo(nameLabel.snp.bottom).offset(1)
        }
        amountLabel.snp.makeConstraints{
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(28)
        }
        timeStampLabel.snp.makeConstraints{
            $0.bottom.equalTo(typeLabel)
            $0.trailing.equalTo(amountLabel)
            $0.top.equalTo(typeLabel)
        }
    }
    
    // MARK: Func
    
    func configure(_ transaction: TransactionData) {
        print("configure함수 실행")
        nameLabel.text = transaction.name
        typeLabel.text = transaction.type
        let amount = Double(transaction.amount) ?? 0.0
        let amountToString = String(format: "%.1f", abs(amount)) // 절댓값으로 변환
        amountLabel.text = amount < 0 ? "-$\(amountToString)" : "+$\(amountToString)"
        timeStampLabel.text = timestampFormat(transaction.timestamp)
        
    }

    private func timestampFormat(_ dateString: String) -> String {
        // 입력 형식 설정
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        // 문자열을 Date로 변환
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        
        // 출력 형식 설정
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
