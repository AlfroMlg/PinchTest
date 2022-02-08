//
//  PhotosCollectionVC.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class PhotosCollectionVC: UIViewController {
    
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    public var photos = PublishSubject<[Photos]>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupBinding(){
        
        photosCollectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        
        photos.bind(to: photosCollectionView.rx.items(cellIdentifier: "PhotosCollectionViewCell", cellType: PhotosCollectionViewCell.self)) {  (row,photos,cell) in
            cell.photo = photos
            }.disposed(by: disposeBag)
        
        photosCollectionView.rx.itemSelected.subscribe(onNext: {IndexPath in
            guard let cell = self.photosCollectionView.cellForItem(at: IndexPath) as? PhotosCollectionViewCell else {
                return
            }
            self.performSegue(withIdentifier: "PhotoDetail", sender: cell)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? PhotosCollectionViewCell else {
            return
        }
        if segue.identifier == "PhotoDetail", let photoDetail = segue.destination as? PhotoDetailVC {
            photoDetail.url = cell.photoUrl
            photoDetail.aTitle = cell.albumTitle.text ?? ""
        }
    }
}
