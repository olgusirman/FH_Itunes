//
//  MediaCell.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

final class MediaCell: UICollectionViewCell, NibIdentifiable & ClassIdentifiable {

    @IBOutlet fileprivate weak var mediaImageView: UIImageView!
    @IBOutlet fileprivate weak var mediaTitle: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImageView.image = nil
        mediaTitle.text = ""
    }
    
    func configure(item: ItunesItem) {
        mediaTitle.text = item.artistName
        mediaImageView.contentMode = .scaleAspectFill
        mediaImageView.setImage(urlString: item.artworkUrl60)
    }
        
}
