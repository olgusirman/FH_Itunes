//
//  MediasWorker.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

protocol MediasStoreProtocol {
    func fetchMedias(request: Medias.FetchMedias.Request,
                     completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void)
    func deleteMedia(request: Medias.DeleteMedia.Request,
                     completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void)
}

final class MediasWorker {
    var ordersStore: MediasStoreProtocol
    
    init(ordersStore: MediasStoreProtocol) {
        self.ordersStore = ordersStore
    }
    
    func fetchMedias(request: Medias.FetchMedias.Request,
                     completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
        
        ordersStore.fetchMedias(request: request) { (itunesMainData, error) in
            DispatchQueue.main.async {
                
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(itunesMainData, nil)
            }
        }
    }
    
    func deleteMedia(request: Medias.DeleteMedia.Request, completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
        ordersStore.deleteMedia(request: request, completionHandler: completionHandler)
    }
    
}

