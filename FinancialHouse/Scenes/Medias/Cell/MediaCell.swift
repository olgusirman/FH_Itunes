//
//  MediaCell.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

final class MediaCell: UICollectionViewCell, NibIdentifiable & ClassIdentifiable {

    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var mediaImageView: MediaArtworkImageView!
    @IBOutlet fileprivate weak var mediaTitle: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImageView.cancelDownloadTask()
        mediaImageView.image = nil
        mediaTitle.text = ""
    }
    
    // MARK: - Configure

    func configure(item: Medias.FetchMedias.ViewModel.DisplayedMedia) {
        mediaTitle.text = item.mediaName
        mediaImageView.setImage(urlString: item.mediaArtworkUrl)
    }
        
}
