//
//  MediaDetailPresenter.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import UIKit

protocol MediaDetailPresentationLogic {
    func presentMediaDetail(response: MediaDetail.ShowMedia.Response)
}

class MediaDetailPresenter: MediaDetailPresentationLogic {
    
    weak var viewController: MediaDetailDisplayLogic?
    
    // MARK: Present Media Detail
    
    func presentMediaDetail(response: MediaDetail.ShowMedia.Response) {
        guard let item = response.item else { return }
        
        let displayedMedia = MediaDetail.ShowMedia.ViewModel.DisplayedMedia(
            id: "\(item.collectionId ?? 0)",
            mediaArtworkUrl: item.artworkUrl600 ?? "",
            mediaName: item.artistName ?? "")
        
        let viewModel = MediaDetail.ShowMedia.ViewModel(displayedMedia: displayedMedia)
        viewController?.displayMedia(viewModel: viewModel)
    }
}
