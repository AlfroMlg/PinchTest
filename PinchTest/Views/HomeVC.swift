//
//  ViewController.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 7/2/22.
//


import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    // MARK: - SubViews
    @IBOutlet weak var tracksVCView: UIView!
    
    private lazy var albumsViewController: AlbumsTableViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "TracksTableViewVC") as! AlbumsTableViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: tracksVCView)
        viewController.setupBinding()
        return viewController
    }()
    
    
    var homeViewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: - View's Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBlurArea(area: self.view.frame, style: .dark)
        setupBindings()
        getData()
    }
    
    
    private func getData() {
        homeViewModel.callToData(dataType: .albums(page: 1), result: [Album].self)
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        // binding loading to vc
        
        homeViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        
        // observing errors to show
        
        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: disposeBag)
        
        // binding tracks to track container
        homeViewModel
            .albums
            .observeOn(MainScheduler.instance)
            .bind(to: albumsViewController.albums)
            .disposed(by: disposeBag)
       
    }
}
