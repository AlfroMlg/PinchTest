//
//  PhotosVC.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class PhotosVC: UIViewController {
    var id, userId: Int?
    
    var photosViewModel = PhotosViewModel(networkManager: NetworkManager<DataType>())
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var photosVCView: UIView!
    
    private lazy var photosViewController: PhotosCollectionVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Photos", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PhotosCollectionVC") as! PhotosCollectionVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: photosVCView)
        viewController.setupBinding()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        getData()
        
    }
    
    private func getData() {
        guard let userId = self.userId else {
            return
        }
        photosViewModel.callToData(dataType: .photos(userId: userId), result: [Photos].self)
    }
    
    private func setupBindings() {
        
        // binding loading to vc
        photosViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        
        photosViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: disposeBag)
        
        // binding photos to track container
        photosViewModel
            .photos
            .observe(on: MainScheduler.instance)
            .bind(to: photosViewController.photos)
            .disposed(by: disposeBag)
    }
}
