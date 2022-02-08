//
//  AlbumCell.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumTitle: UILabel!
    var id, userId: Int?
    
    
    public var cellAlbum : Album! {
        didSet {
            self.albumTitle.text = cellAlbum.title
            self.userId = cellAlbum.userID
            self.id = cellAlbum.id
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
}
