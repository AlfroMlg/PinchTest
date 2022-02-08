//
//  AlbumsTableViewVC.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsTableViewVC: UIViewController {
    
    
    @IBOutlet private weak var albumsTableView: UITableView!
    
    public var albums = PublishSubject<[Album]>()
    
    private let disposeBag = DisposeBag()
    
    private lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupBinding(){
        
        albumsTableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: String(describing: AlbumCell.self))
        
        albums.bind(to: albumsTableView.rx.items(cellIdentifier: "AlbumCell", cellType: AlbumCell.self)) {  (row,album,cell) in
            cell.cellAlbum = album
            }.disposed(by: disposeBag)
        
        
        albumsTableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
    }
}

