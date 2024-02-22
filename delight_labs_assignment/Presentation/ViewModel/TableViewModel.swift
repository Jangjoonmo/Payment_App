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
        let allTransactions = BehaviorSubject(value: [TransactionData]())
         let expenseTransactions = BehaviorSubject(value: [TransactionData]())
         let incomeTransactions = BehaviorSubject(value: [TransactionData]())
        
        input.allTrigger
            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
                guard let self = self else { return .empty() }
                let transactions = self.transactionManager.getLast20Transactions()
//                print("Retrieved transactions: \(transactions)")
                return .just(transactions)
            }
            .bind(to: allTransactions)
            .disposed(by: disposeBag)
        
        input.expenseTrigger
            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
                guard let self = self else { return .empty() }
                let transactions = self.transactionManager.getLast10ExpenseTransactions()
//                print("Retrieved transactions: \(transactions)")
                return .just(transactions)
            }
            .bind(to: expenseTransactions)
            .disposed(by: disposeBag)
        
        input.incomeTrigger
            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
                guard let self = self else { return .empty() }
                let transactions = self.transactionManager.getLast10IncomeTransactions()
//                print("Retrieved transactions: \(transactions)")
                return .just(transactions)
            }
            .bind(to: expenseTransactions)
            .disposed(by: disposeBag)
        
        return Output(allTransactions: allTransactions.asObservable(),
                      expenseTransactions: expenseTransactions.asObservable(),
                      incomeTransactions: incomeTransactions.asObservable(),
                      error: errorTracker.asObservable())
    }
}
