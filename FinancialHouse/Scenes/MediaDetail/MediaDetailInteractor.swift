//
//  MediaDetailInteractor.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import UIKit

protocol MediaDetailBusinessLogic {
    func getItem(request: MediaDetail.ShowMedia.Request)
    func presentDeleteItemPopUp( deleteHandler: @escaping () -> Void ) -> UIAlertController
}

protocol MediaDetailDataStore {
    var item: ItunesItem? { get set }
}

final class MediaDetailInteractor: MediaDetailBusinessLogic, MediaDetailDataStore {
    var presenter: MediaDetailPresentationLogic?
    var worker: MediaDetailWorker?
    var item: ItunesItem?
    
    // MARK: Do something
    
    func getItem(request: MediaDetail.ShowMedia.Request) {
        let response = MediaDetail.ShowMedia.Response(item: item)
        presenter?.presentMediaDetail(response: response)
    }
    
    func presentDeleteItemPopUp( deleteHandler: @escaping () -> Void ) -> UIAlertController {
        let controller = UIAlertController(title: "Delete?", message: "Do you want to delete this media?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            self.deleteItem()
            deleteHandler()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        return controller
    }
    
    private func deleteItem() {
        if let item = item {
            NotificationCenter.default.post(name: .itemDeleted, object: item)
        }
    }
}
