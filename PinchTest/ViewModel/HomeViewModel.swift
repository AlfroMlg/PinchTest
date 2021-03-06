//
//  HomeViewModel.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class HomeViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let albums : PublishSubject<[Album]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error: PublishSubject<HomeError> = PublishSubject()
    public let refresh: PublishSubject<Void> = PublishSubject()
    private let disposable = DisposeBag()
    var networkManager: NetworkManager<DataType>
    
    init(networkManager: NetworkManager<DataType>) {
        self.networkManager = networkManager
    }
    
    func callToData<K: Codable>(dataType : DataType, result: [K].Type) {
        self.loading.onNext(true)
        networkManager.request(route: dataType) { [weak self] (results:Result<[K], Error>) in
            
            self?.loading.onNext(false)
            self?.refresh.onNext(())
            if let data: Result<[Album], Error> = results as? Result<[Album], Error> {
                switch data {
                case .success(let albumData):
                    self?.albums.onNext(albumData)
                case .failure(let failure):
                    self?.error.onNext(.serverMessage(failure.localizedDescription))
                }
            }
        }
    }
}
