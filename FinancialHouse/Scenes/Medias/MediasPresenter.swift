//
//  MediasPresenter.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

protocol MediasPresentationLogic {
    func presentMedia(response: Medias.FetchMedias.Response)
    func configurePlaceholder(dependsOnThe type: Medias.FetchMedias.MediaType)
    func deleteMedia(response: Medias.DeleteMedia.Response)
    func updateMedia(response: Medias.UpdateMedia.Response)
}

final class MediasPresenter: MediasPresentationLogic {
    weak var viewController: MediasDisplayLogic?
    
    // MARK: Present Media
    
    /// Manipulate the response data business logic and turn into the viewModel presentation logic for views
    func presentMedia(response: Medias.FetchMedias.Response) {
        guard let items = response.items else {
            return
        }
        
        let displayedMedias = items.map({
            Medias.FetchMedias.ViewModel.DisplayedMedia(id: "\($0.collectionId ?? 0)",
                                                        mediaArtworkUrl: $0.artworkUrl100 ?? "",
                                                        mediaName: $0.artistName ?? "",
                                                        isSelected: $0.isSelected)
        })
        
        let viewModel = Medias.FetchMedias.ViewModel(displayedMedias: displayedMedias)
        viewController?.displayItems(viewModel: viewModel)
    }
    
    func configurePlaceholder(dependsOnThe type: Medias.FetchMedias.MediaType) {
        let placeholderString: String
        switch type {
        case .all: placeholderString = "Search all iTunes Media..."
        case .movie: placeholderString = "Search iTunes Movie..."
        case .podcast: placeholderString = "Search iTunes Podcast..."
        case .music: placeholderString = "Search iTunes Music..."
        }
        
        viewController?.configureSearchBarPlaceholder(placeholder: placeholderString)
    }
    
    func deleteMedia(response: Medias.DeleteMedia.Response) {
        let viewModel = Medias.DeleteMedia.ViewModel(result: response.result, itemsAfterDeleted: response.itemsAfterDeleted, deletedIndexPath: response.deletedIndexPath)
        viewController?.deleteMedia(viewModel: viewModel)
    }
    
    func updateMedia(response: Medias.UpdateMedia.Response) {
        viewController?.updateMedia(viewModel: Medias.UpdateMedia.ViewModel(updatedIndexPath: response.updatedIndexPath))
    }
}
