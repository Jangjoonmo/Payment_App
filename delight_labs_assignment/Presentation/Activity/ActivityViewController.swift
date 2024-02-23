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
import SwiftUI

class ActivityViewController: UIViewController {

    // MARK: Variables
    
    let scrollView = UIScrollView()
    let contentView = UIView() // 스크롤 뷰 안의 콘텐츠 뷰 추가
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    let topBar = TransactionTopBarView()
    var topView = LineChartTopView()

    lazy var tableView: UITableView = UITableView().then{
        $0.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.cellID)
        $0.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderView.CellID)
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }

    var chartView: UIHostingController<ContentView>!
    var lineChartViewModel = LineChartViewModel()
    
    let transactionManager = TransactionManager()
    var tableViewModel: TableViewModel!
    let allTrigger = PublishSubject<Void>()
    let expenseTrigger = PublishSubject<Void>()
    let incomeTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setUpView()
        setUpDelegate()
        
        tableViewModel = TableViewModel(transactionManager: transactionManager)
        topView.viewModel = lineChartViewModel
          
        let contentView = ContentView(viewModel: lineChartViewModel)
        chartView = UIHostingController(rootView: contentView)
          
        addChild(chartView)
        chartView.didMove(toParent: self)
        
        setUpLayout()
        setUpConstraint()
        
        bindViewModel()
        allTrigger.onNext(())
//        transactionManager.parseJSON()
    }
    
    func setUpDelegate() {
        tableView.delegate = self
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
        [topBar, topView, chartView.view, tableView]
            .forEach{contentView.addSubview($0)}
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
        topBar.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(36)
        }
        topView.snp.makeConstraints{
            $0.top.equalTo(topBar.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(66)
        }
        
        chartView.view.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(47)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(232)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(chartView.view.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1200)

        }
        
    }
    
    // MARK: BindViewModel
    
    private func bindViewModel() {

        let trigger = Observable.merge(
            allTrigger.map { TransactionType.all },
            expenseTrigger.map { TransactionType.expense },
            incomeTrigger.map { TransactionType.income }
        )
        
        let input = TableViewModel.Input(trigger: trigger)
        let output = tableViewModel.transform(input: input)
        
        output.transactions
            .bind(to: tableView.rx.items(cellIdentifier: TransactionTableViewCell.cellID,
                                         cellType: TransactionTableViewCell.self)) { index, model, cell in
                cell.configure(model)
            }.disposed(by: disposeBag)
        
        output.error.subscribe(onNext: { error in
            print(error)
        }).disposed(by: disposeBag)

    }
    

    
    // MARK: Function
    
    @objc func notificationTapped() {
        print("알림 버튼 클릭")
        
    }

}
extension ActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    //헤더 등록 및 rx 바인딩
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderView.CellID) as! TableViewHeaderView
        header.updateData.subscribe(onNext: { [weak self] ButtonType in
            switch ButtonType {
                
            case .all:
                print("최근 입출금 20건 버튼 클릭")
                self?.allTrigger.onNext(())
            case .expense:
                print("최근 출금 10건 버튼 클릭")
                self?.expenseTrigger.onNext(())
            case .income:
                print("최근 입금 10건 버튼 클릭")
                self?.incomeTrigger.onNext(())
            }
            
        }).disposed(by: disposeBag)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 111
    }
    
    
}

//import SwiftUI
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        ViewController().toPreview()
//            // .edgesIgnoringSafeArea(.all)
//    }
//}
