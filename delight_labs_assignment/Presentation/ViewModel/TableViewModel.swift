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
    
    func transform(input: Input) -> Output {
        let errorSubject = PublishSubject<Error>()

        let allTransactions = input.allTrigger.flatMapLatest { _ -> Observable<[TransactionData]> in
            return DataLoadSaveManager.shared.isDataLoaded
                .filter { $0 } // isLoaded가 true인 경우만 방출
                .flatMap { _ in Observable.just(getRecentTransactions()) }
        }

        let expenseTransactions = input.expenseTrigger.flatMapLatest { _ -> Observable<[TransactionData]> in
            return Observable.just(getRecentExpenses())
        }

        let incomeTransactions = input.incomeTrigger.flatMapLatest { _ -> Observable<[TransactionData]> in
            return Observable.just(getRecentIncomes())
        }
        
        return Output(allTransactions: allTransactions,
                      expenseTransactions: expenseTransactions,
                      incomeTransactions: incomeTransactions,
                      error: errorSubject.asObserver())
    }
}
