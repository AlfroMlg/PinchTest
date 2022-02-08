//
//  HomeVC.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 7/2/22.
//


import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    // MARK: - SubViews
    @IBOutlet weak var albumsView: UIView!
    let refreshControl = UIRefreshControl()
    private lazy var albumsViewController: AlbumsTableViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AlbumsTableViewVC") as! AlbumsTableViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: albumsView)
        viewController.setupBinding()
        viewController.albumsTableView.refreshControl = self.refreshControl
        viewController.albumsTableView.refreshControl?.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            self?.homeViewModel.callToData(dataType:  .albums(page: 1), result: [Album].self)
        }).disposed(by: disposeBag)
        return viewController
    }()
    
    
    var homeViewModel = HomeViewModel(networkManager: NetworkManager<DataType>())
    
    let disposeBag = DisposeBag()
    
    // MARK: - View's Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        getData()
    }
    
    
    private func getData() {
        homeViewModel.callToData(dataType: .albums(page: 1), result: [Album].self)
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        // binding loading to vc
        homeViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        homeViewModel.refresh
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.refreshControl.endRefreshing()
            }.disposed(by: disposeBag)

        
        
        // observing errors to show
        homeViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
                
            }).disposed(by: disposeBag)
        
        // binding tracks to track container
        homeViewModel
            .albums
            .observe(on: MainScheduler.instance)
            .bind(to: albumsViewController.albums)
            .disposed(by: disposeBag)
    }
}
