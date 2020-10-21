//
//  MediaDetailModels.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import UIKit

enum MediaDetail {
    // MARK: Use cases
    
    enum ShowMedia {
        struct Request {
        }
        struct Response {
            var item: ItunesItem?
        }
        struct ViewModel {
            struct DisplayedMedia: Identifiable {
                var id: String
                var mediaArtworkUrl: String
                var mediaName: String
            }
            
            var displayedMedia: DisplayedMedia
        }
    }
}
