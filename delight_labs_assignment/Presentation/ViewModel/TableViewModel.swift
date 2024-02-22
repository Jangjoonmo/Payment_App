//
//  TransactionViewModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import Foundation
import RxSwift
import UIKit

class TableViewModel {
    
    private let transactionManager: TransactionManager
    let disposeBag = DisposeBag()

    struct Input {
        let allTrigger: Observable<Void>
        let expenseTrigger: Observable<Void>
        let incomeTrigger: Observable<Void>
    }
    
    struct Output {
        let allTransactions: Observable<[TransactionData]>
        let expenseTransactions: Observable<[TransactionData]>
        let incomeTransactions: Observable<[TransactionData]>
        let error: Observable<Error>
    }
    
    init(transactionManager: TransactionManager) {
        self.transactionManager = transactionManager
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = PublishSubject<Error>()
        let allTransactions = PublishSubject<[TransactionData]>()
        let expenseTransactions = PublishSubject<[TransactionData]>()
        let incomeTransactions = PublishSubject<[TransactionData]>()
        
        input.allTrigger
            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
                guard let self = self else { return .empty() }
                return .just(self.transactionManager.getLast20Transactions())
            }
            .bind(to: allTransactions)
            .disposed(by: disposeBag)
//        
//        input.expenseTrigger
//            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
//                guard let self = self else { return .empty() }
//                if let transactions = self.transactionManager.fetchRecentExpenseTransactions(limit: 10) {
//                    return .just(transactions)
//                } else {
//                    return .empty()
//                }
//            }
//            .bind(to: expenseTransactions)
//            .disposed(by: disposeBag)
//        
//        input.incomeTrigger
//            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
//                guard let self = self else { return .empty() }
//                if let transactions = self.transactionManager.fetchRecentIncomeTransactions(limit: 10) {
//                    return .just(transactions)
//                } else {
//                    return .empty()
//                }
//            }
//            .bind(to: incomeTransactions)
//            .disposed(by: disposeBag)
        
        return Output(allTransactions: allTransactions.asObservable(),
                      expenseTransactions: expenseTransactions.asObservable(),
                      incomeTransactions: incomeTransactions.asObservable(),
                      error: errorTracker.asObservable())
    }
}
