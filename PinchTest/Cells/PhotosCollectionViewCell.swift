//
//  PhotosCollectionViewCell.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    var photoUrl: String?
    
    public var photo: Photos! {
        didSet {
            self.albumImage.loadImage(fromURL: photo.thumbnailURL)
            self.albumTitle.text = photo.title
            self.photoUrl = photo.url
        }
    }
    
    private func backViewGenrator(){
    }
    
    override func prepareForReuse() {
        albumImage.image = UIImage()
    }
}
