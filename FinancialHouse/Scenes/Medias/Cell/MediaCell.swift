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
    
    override var isHighlighted: Bool {
        didSet {
            let duration = isHighlighted ? 0.45 : 0.4
            let transform = isHighlighted ?
                CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
            let bgColor = isHighlighted ?
                UIColor(white: 1.0, alpha: 0.2) : UIColor(white: 1.0, alpha: 0.1)
            let animations = {
                self.transform = transform
                //self.bgView.backgroundColor = bgColor
                self.backgroundView?.backgroundColor = bgColor
            }
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: animations,
                           completion: nil)
        }
    }
        
}
