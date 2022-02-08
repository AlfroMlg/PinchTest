//
//  PhotosViewModel.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosViewModel {
    public enum PhotosError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<PhotosError> = PublishSubject()
    public let photos : PublishSubject<[Photos]> = PublishSubject()
    private let disposable = DisposeBag()
    
    var networkManager: NetworkManager<DataType>
    
    init(networkManager: NetworkManager<DataType>) {
        self.networkManager = networkManager
    }
    
    func callToData<K: Codable>(dataType : DataType, result: [K].Type) {
        
        self.loading.onNext(true)
        
        networkManager.request(route: dataType) { [weak self] (results:Result<[K], Error>) in
            
            self?.loading.onNext(false)
            
            if let data: Result<[Photos], Error> = results as? Result<[Photos], Error> {
                switch data {
                case .success(let photos):
                    self?.photos.onNext(photos)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
