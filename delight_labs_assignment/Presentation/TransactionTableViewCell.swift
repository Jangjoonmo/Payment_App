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
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    var nameLabel: UILabel = UILabel().then{
        $0.text = "Name"
        $0.font = .systemFont(ofSize: 16)
        $0.sizeToFit()
    }
    
    var typeLabel: UILabel = UILabel().then{
        $0.text = "Transfer"
        $0.font = .systemFont(ofSize: 14)
    }
    
    var amountLabel: UILabel = UILabel().then{
        $0.text = "+$432.9"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = UIColor(named: "MainColor")
        $0.textAlignment = .right
        $0.sizeToFit()
    }
    
    var timeStampLabel: UILabel = UILabel().then{
        $0.text = "3.30 AM"
        $0.font = .systemFont(ofSize: 14)
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
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
