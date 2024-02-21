//
//  TransactionViewModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import Foundation
import RxSwift
import UIKit

class TransactionViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let transactionTrigger: Observable<Void>
    }
    
    struct Output {
        let transactions: Observable<[Transaction]>
        let error: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        let errorSubject = PublishSubject<Error>()
        let transactions = input.transactionTrigger.flatMapLatest { _ -> Observable<[Transaction]> in
            return Observable.create { observer -> Disposable in
                self.fetchTransactions { result in
                    switch result {
                    case .success(let transactions):
                        observer.onNext(transactions)
                        observer.onCompleted()
                    case .failure(let error):
                        errorSubject.onNext(error)
                    }
                }
                return Disposables.create()
            }
        }
        
        return Output(transactions: transactions, error: errorSubject.asObserver())
    }

    private func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.dispatchGroup.notify(queue: .main) {
            let url = getDocumentsDirectory().appendingPathComponent("latestTransactions.json")
            do {
                let data = try Data(contentsOf: url)
                let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                completion(.success(transactions))
            } catch {
                completion(.failure(error))
            }
        }

    }
}
