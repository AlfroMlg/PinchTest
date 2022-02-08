//
//  HomeViewModel.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let albums : PublishSubject<[Album]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    func callToData<K: Codable>(dataType : DataType, result: [K].Type) {
        
        self.loading.onNext(true)
        
        let networkManager = NetworkManager<DataType>()
        networkManager.request(route: dataType) { [weak self] (results:Result<[K], Error>) in
            
            self?.loading.onNext(false)
            
            if let data: Result<[Album], Error> = results as? Result<[Album], Error> {
                switch data {
                case .success(let albumData):
                    self?.albums.onNext(albumData)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
