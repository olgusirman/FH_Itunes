//
//  MediasModels.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

enum Medias {
    // MARK: Use cases
    
    enum FetchMedias {
        enum MediaType: String {
            case podcast
            case movie
            case music
            case all
        }
        
        struct Request {
            var term: String
            var media: MediaType = .all
            var limit: Int = 100
        }
        
        struct Response {
            var items: [ItunesItem]?
        }
        
        struct ViewModel {
            struct DisplayedMedia: Identifiable {
                var id: String
                var mediaArtworkUrl: String
                var mediaName: String
                var isSelected: Bool
            }
            
            var displayedMedias: [DisplayedMedia]
        }
    }
    
    enum DeleteMedia {
        struct Request {
            var item: ItunesItem
        }
        
        struct Response {
            var result: Result<ItunesItem, Error>
            var itemsAfterDeleted: [ItunesItem]?
            var deletedIndexPath: IndexPath?
        }
        
        struct ViewModel {
            var result: Result<ItunesItem, Error>
            var itemsAfterDeleted: [ItunesItem]?
            var deletedIndexPath: IndexPath?
        }
    }
    
    enum UpdateMedia {
        struct Request {
        }
        
        struct Response {
            var updatedIndexPath: IndexPath?
        }
        
        struct ViewModel {
            var updatedIndexPath: IndexPath?
        }
    }
}
