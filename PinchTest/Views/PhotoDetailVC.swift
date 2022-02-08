//
//  PhotoDetailVC.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import UIKit
import RxSwift
import RxCocoa
class PhotoDetailVC: UIViewController {
    
    var url: String?
    var aTitle: String?
    
    @IBOutlet weak var albumTitle: UILabel!
    
    @IBOutlet weak var albumImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        self.albumTitle.text = aTitle
    }
    
    private func getImage() {
        guard let imageUrl = url else {
            return
        }
        albumImage.loadImage(fromURL: imageUrl)
    }
}
