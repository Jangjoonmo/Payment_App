//
//  ViewController.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    // MARK: Variables
    
    let scrollView = UIScrollView()
    let contentView = UIView() // 스크롤 뷰 안의 콘텐츠 뷰 추가
    let topView = TransactionTopView()
    let recentTransactionsHeaderView = RecentTransactionButtonView()
    var tableView: UITableView = UITableView().then{
        $0.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.cellID)
        $0.isScrollEnabled = false
    }
    
    let viewModel = TransactionViewModel()
    let transactionTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpLayout()
        setUpConstraint()
        bindViewModel()
    }
    
    
    // MARK: View
    
    func setUpView() {
        view.backgroundColor = .white
    }
    
    
    // MARK: Layout
    
    func setUpLayout() {
        self.view.addSubview(scrollView)
        [topView, recentTransactionsHeaderView, tableView]
            .forEach{scrollView.addSubview($0)}
        
    }
    
    // MARK: BindViewModel
    
    private func bindViewModel() {
        let input = TransactionViewModel.Input(transactionTrigger: transactionTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.transactions.subscribe(onNext: { transactions in
            
        }).disposed(by: disposeBag)
        
        output.error.subscribe(onNext: { error in
            print(error)
        }).disposed(by: disposeBag)
        
    }
    
    
    // MARK: Constraint
    
    func setUpConstraint() {
        
    }
    
    // MARK: Function



}

