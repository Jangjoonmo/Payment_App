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
    
    private let transactionManager: TransactionManager
    let disposeBag = DisposeBag()

    struct Input {
        let trigger: Observable<TransactionType>
//        let expenseTrigger: Observable<Void>
//        let incomeTrigger: Observable<Void>
    }
    
    struct Output {
        let transactions: Observable<[TransactionData]>
//        let expenseTransactions: Observable<[TransactionData]>
//        let incomeTransactions: Observable<[TransactionData]>
        let error: Observable<Error>
    }
    
    init(transactionManager: TransactionManager) {
        self.transactionManager = transactionManager
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = PublishSubject<Error>()
        let transactions = BehaviorSubject(value: [TransactionData]())
//         let expenseTransactions = BehaviorSubject(value: [TransactionData]())
//         let incomeTransactions = BehaviorSubject(value: [TransactionData]())
        
        input.trigger
            .flatMapLatest { [weak self] type -> Observable<[TransactionData]> in
                guard let self = self else { return .empty() }
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
            .bind(to: transactions)
            .disposed(by: disposeBag)
        
//        input.expenseTrigger
//            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
//                guard let self = self else { return .empty() }
//                let transactions = self.transactionManager.getLast10ExpenseTransactions()
////                print("Retrieved transactions: \(transactions)")
//                return .just(transactions)
//            }
//            .bind(to: expenseTransactions)
//            .disposed(by: disposeBag)
//        
//        input.incomeTrigger
//            .flatMapLatest { [weak self] _ -> Observable<[TransactionData]> in
//                guard let self = self else { return .empty() }
//                let transactions = self.transactionManager.getLast10IncomeTransactions()
////                print("Retrieved transactions: \(transactions)")
//                return .just(transactions)
//            }
//            .bind(to: expenseTransactions)
//            .disposed(by: disposeBag)
        
        return Output(transactions: transactions.asObservable(), error: errorTracker.asObservable())
    }
}
