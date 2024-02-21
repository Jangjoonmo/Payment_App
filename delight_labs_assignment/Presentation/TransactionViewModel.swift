//
//  TransactionViewModel.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/21/24.
//

import Foundation
import RxSwift

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
        let url = URL(string: "https://drive.google.com/u/0/uc?id=1nGe0wgoNRM-VAPF53wSEfqtKwU0BKfEV&export=download")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "데이터가 없습니다."])
                completion(.failure(error))
                return
            }

            let decoder = JSONDecoder()
            do {
                let transactions = try decoder.decode([Transaction].self, from: data)
                completion(.success(transactions))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
