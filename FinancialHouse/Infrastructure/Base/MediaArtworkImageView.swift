//
//  MediaArtworkImageView.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import UIKit

final class MediaArtworkImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.image = UIImage(named: "placeholder")
    }

}
