//
//  ViewController.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        transactionTrigger.onNext(())
    }
    
    
    // MARK: View
    
    func setUpView() {
        view.backgroundColor = .white
    }
    
    
    // MARK: Layout
    
    func setUpLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [topView, recentTransactionsHeaderView, tableView]
            .forEach{contentView.addSubview($0)}
    }
    
    // MARK: BindViewModel
    
    private func bindViewModel() {
        let input = TransactionViewModel.Input(transactionTrigger: transactionTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.transactions.bind(to: tableView.rx.items(cellIdentifier: TransactionTableViewCell.cellID, cellType: TransactionTableViewCell.self)) { row, transaction, cell in
            cell.configure(transaction)
        }.disposed(by: disposeBag)
        
        output.error.subscribe(onNext: { error in
            print(error)
        }).disposed(by: disposeBag)
        
    }
    
    
    // MARK: Constraint
    
    func setUpConstraint() {
        scrollView.snp.makeConstraints{
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()    
        }
        contentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        topView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(66)
        }
        recentTransactionsHeaderView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(30)   // Fix
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(81)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(recentTransactionsHeaderView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    // MARK: Function



}

import SwiftUI
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewController().toPreview()
            // .edgesIgnoringSafeArea(.all)
    }
}
