//
//  ViewController.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ViewController: UIViewController {

    // MARK: Variables
    
    let scrollView = UIScrollView()
    let contentView = UIView() // 스크롤 뷰 안의 콘텐츠 뷰 추가
    let loadingIndicator = UIActivityIndicatorView(style: .large)

    let topView = TransactionTopView()
    let recentTransactionsHeaderView = RecentTransactionButtonView()
    lazy var tableView: UITableView = UITableView().then{
        $0.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.cellID)
        $0.isScrollEnabled = false
    }
    
    
    let transactionManager = TransactionManager()
    var viewModel: TableViewModel!
    let allTrigger = PublishSubject<Void>()
    let expenseTrigger = PublishSubject<Void>()
    let incomeTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setUpView()
        setUpLayout()
        setUpConstraint()
        viewModel = TableViewModel(transactionManager: transactionManager)

        bindViewModel()
        bindView()
        
        allTrigger.onNext(())
    }
    
    func setUpDelegate() {
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.delegate = nil
        tableView.dataSource = nil
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
        let input = TableViewModel.Input(allTrigger: allTrigger.asObservable(),
                                         expenseTrigger: expenseTrigger.asObservable(),
                                         incomeTrigger: incomeTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        output.allTransactions
            .do(onNext: { transactions in
                print("바인드 전 transactions: \(transactions)")
            })
            .bind(to: tableView.rx.items(cellIdentifier: TransactionTableViewCell.cellID, cellType: TransactionTableViewCell.self)) { index, model, cell in
                cell.configure(model)
            }.disposed(by: disposeBag)
        
        output.error.subscribe(onNext: { error in
            print(error)
        }).disposed(by: disposeBag)
        
    }
    
    private func bindView() {
        recentTransactionsHeaderView.allButton.rx.tap.bind { [weak self] in
            self?.allTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        recentTransactionsHeaderView.incomeButton.rx.tap.bind { [weak self] in
            self?.incomeTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        recentTransactionsHeaderView.expenseButton.rx.tap.bind { [weak self] in
            self?.expenseTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
    
    
    // MARK: Constraint
    
    func setUpConstraint() {
        scrollView.snp.makeConstraints{
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()    
            $0.height.equalTo(1200)
        }
        contentView.snp.makeConstraints{
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(1200)
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
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 51
//    }
//}

//import SwiftUI
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewController().toPreview()
//            // .edgesIgnoringSafeArea(.all)
//    }
//}
