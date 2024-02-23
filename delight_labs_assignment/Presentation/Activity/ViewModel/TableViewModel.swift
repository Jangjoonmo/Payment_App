//
//  TransactionViewModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import Foundation
import RxSwift
import UIKit

enum TransactionType {
    case all
    case expense
    case income
}

class TableViewModel {
    
    @Published var isLoading = false
    private let transactionManager: TransactionManager
    let disposeBag = DisposeBag()

    struct Input {
        let trigger: Observable<TransactionType>
    }
    
    struct Output {
        let transactions: Observable<[TransactionData]>
        let error: Observable<Error>
    }
    
    init(transactionManager: TransactionManager) {
        self.transactionManager = transactionManager
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = PublishSubject<Error>()
        let transactions = BehaviorSubject(value: [TransactionData]())
        
        input.trigger
            .flatMapLatest { [weak self] type -> Observable<[TransactionData]> in
                guard let self = self else { return .empty() }
                isLoading = true
                switch type {
                case .all:
                    let transactions = self.transactionManager.getLast20Transactions()
                    return .just(transactions)
                case .expense:
                    let transactions = self.transactionManager.getLast10ExpenseTransactions()
                    return .just(transactions)
                case .income:
                    let transactions = self.transactionManager.getLast10IncomeTransactions()
                    return .just(transactions)
                }
            }
            .do(onNext: { [weak self] _ in
                self?.isLoading = false  // 로딩 종료
            }, onError: { [weak self] _ in
                self?.isLoading = false  // 에러 발생 시 로딩 종료
            })
            .bind(to: transactions)
            .disposed(by: disposeBag)
        
        return Output(transactions: transactions.asObservable(), error: errorTracker.asObservable())
    }
}
